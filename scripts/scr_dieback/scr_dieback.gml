// NOTE: Due to how Dieback functions, It WILL break gpu batches. Sorry!

// Hides all parameter name suggestions.
// feather disable GM1042

/// DIEBACK INSTANCE

///@function dieback_inst()
///@desc Create an uninitalized background. Use .load to initialize.
///@return {Struct.Dieback}
function DiebackInst() constructor {

	// uniform hell :(
	static axis_distortion_uniforms = {
		tex_uvs : shader_get_uniform(sh_dieback_axis_distortion, "tex_uvs"), //vec4
		palette_uvs : shader_get_uniform(sh_dieback_axis_distortion, "palette_uvs"), //vec4
		tex_size : shader_get_uniform(sh_dieback_axis_distortion, "tex_size"), //ivec2
		tex_offset : shader_get_uniform(sh_dieback_axis_distortion, "tex_offset"), //vec2
		palette_size : shader_get_uniform(sh_dieback_axis_distortion, "palette_size"),
		palette_enabled : shader_get_uniform(sh_dieback_axis_distortion, "palette_enabled"), //bool
		palette_texture : shader_get_sampler_index(sh_dieback_axis_distortion, "palette_texture"), //sampler2D
		palette_index : shader_get_uniform(sh_dieback_axis_distortion, "palette_index"), //float
		axis_mode : shader_get_uniform(sh_dieback_axis_distortion, "axis_mode"), //ivec2
		axis_frequency : shader_get_uniform(sh_dieback_axis_distortion, "axis_frequency"), //ivec2
		axis_amplitude : shader_get_uniform(sh_dieback_axis_distortion, "axis_amplitude"), //ivec2
		axis_shift : shader_get_uniform(sh_dieback_axis_distortion, "axis_shift") //vec2
	};
	
	static planar_distortion_uniforms = {
		tex_size : shader_get_uniform(sh_dieback_planar_distortion, "tex_size"), //ivec2
		planar_mode : shader_get_uniform(sh_dieback_planar_distortion, "planar_mode"), //int
		planar_amplitude : shader_get_uniform(sh_dieback_planar_distortion, "planar_amplitude") //float
	};

	gtime = 10;
	gid = 0;
	total_layers = 0;
	swap_textures = {
		temp : undefined, // eventually assign to surface
		final : undefined, // not done now because gamemaker surfaces are dangerous! (not really lol)
	};
	data = undefined;
	ui_properties = {}; // seems unused in l2d
	content = {};
	palettes = {};
	content_uv = {};
	palettes_uv = {};
	scripts = {};
	quad = undefined;
	quad_format = undefined;

	///@desc internal usage. Figure it out yourself ;P
	static _decode_image = function(_base_64_string) {
		// this is awful, I really wish there was a better way.
		// potentially you could replace the pngfile
		var _data = buffer_base64_decode(_base_64_string);
		var _outputpath = temp_directory+"FILE.png";
		var _content = buffer_save(_data, _outputpath);
		
		var _image = sprite_add(_outputpath, 1, false, false, 0, 0);
		
		buffer_delete(_data);
		
		// sprite, and index... for native dieback stuff it is always index 0
		return [_image, 0];
	}
	
	///@function load(data_struct)
	///@desc Load a background from a Struct, initializes the background and makes it usable.
	///@param {Struct} data_struct
	static load = function(_data_struct) {
		
		self.data = _data_struct;
		
		self.total_layers = array_length(self.data.layers);
		
		for (var _i = 0; _i < self.total_layers; _i++;) {
			var _v = self.data.layers[_i];
			
			if (_v.back_data != "" && is_string(_v.back_data)) {
				self.content[$ _v.id] = _decode_image(_v.back_data);
				_v.back_data = "free";
			} else if is_array(_v.back_data) { // safely assume that the user did the proper thing...
				self.content[$ _v.id] = _v.back_data;
			}
			
			if (_v.pal_data != "" && is_string(_v.pal_data)) {
				self.palettes[$ _v.id] = _decode_image(_v.pal_data);
				_v.pal_data = "free";
			} else if is_array(_v.pal_data) { // safely assume that the user did the proper thing...
				self.palettes[$ _v.id] = _v.pal_data;
			}
			
			if !is_undefined( self.content[$ _v.id] ) {
				self.content_uv[$ _v.id] = sprite_get_uvs( self.content[$ _v.id][0], self.content[$ _v.id][1] );
			}
			
			if !is_undefined( self.palettes[$ _v.id] ) {
				self.palettes_uv[$ _v.id] = sprite_get_uvs( self.palettes[$ _v.id][0], self.palettes[$ _v.id][1] );
			}
			
			if is_undefined(self.quad_format) {
				vertex_format_begin();
				vertex_format_add_position();
				vertex_format_add_colour();
				vertex_format_add_texcoord();
				self.quad_format = vertex_format_end();	
			}

			if is_undefined(self.quad) {
				var _vb = vertex_create_buffer();
				self.quad = _vb;

				vertex_begin(_vb, self.quad_format);

				vertex_position(_vb, 0, 0); vertex_color(_vb, c_white, 1); 
				vertex_texcoord(_vb, 0, 0);
			
				vertex_position(_vb, self.data.dimensions.x, 0); vertex_color(_vb, c_white, 1); 
				vertex_texcoord(_vb, self.data.dimensions.x, 0);
			
				vertex_position(_vb, 0, self.data.dimensions.y); vertex_color(_vb, c_white, 1); 
				vertex_texcoord(_vb, 0, self.data.dimensions.y);
			
				vertex_position(_vb, self.data.dimensions.x, self.data.dimensions.y); vertex_color(_vb, c_white, 1); 
				vertex_texcoord(_vb, self.data.dimensions.x, self.data.dimensions.y);

				vertex_end(_vb); 
			}
			
			self.gid = _v.id;	
		}
	}
	
	///@function update(time)
	///@desc Update the current BG timer and all script functions if they exist.
	///@param {Real} time
	static update = function(_time) {
		self.gtime = !is_undefined(_time) ? _time : (get_timer()/1_000_000);
		for (var _i = 0; _i < total_layers; _i++;) { // doesn't support love2d scripts...
			var _v = self.data.layers[_i];
			
			if !is_undefined(self.data.layers[_i][$ "callback"]) {
				self.data.layers[_i].callback(self.data.layers[_i]);
			}
		}
		
	}
	
	///@function render(x, y, xscale, yscale, rotation, blend_enable)
	///@desc Render and Draw the dieback background at a desired location.
	///@param {Real} x
	///@param {Real} y
	///@param {Real} xscale
	///@param {Real} yscale
	///@param {Real} rotation
	///@param {Bool} blend_enable
	static render = function(_x, _y, _xscale, _yscale, _rot, _blend) {
		var _time = self.gtime;
		
		static _blend_modes = [ 
			bm_normal, // alpha
			bm_add, // add
			bm_subtract, // sub
			bm_max // screen
		];
		
		static _wrap = function(_x, _x_min, _x_max) {
			return _x - (_x_max - _x_min) * floor(_x / (_x_max - _x_min));	
		}
		
		// gamemaker can be sassy so we ensure the surface exists in render rather than creating it once in load.
		if (!surface_exists(self.swap_textures.final) ) {
			self.swap_textures.final = surface_create(self.data.dimensions.x, self.data.dimensions.y);
		}
		if (!surface_exists(self.swap_textures.temp) ) {
			self.swap_textures.temp = surface_create(self.data.dimensions.x, self.data.dimensions.y);
		}
		
		surface_set_target(self.swap_textures.final);
			// gamemaker L, it thinks alpha should be a color lmao
			// feather ignore once GM1044
			
			draw_clear_alpha(c_black, !_blend);
		surface_reset_target();
		
		var _gpu_state = gpu_get_blendenable();
		gpu_set_blendenable(_blend);
			draw_surface_ext(self.swap_textures.final, _x, _y, _xscale, _yscale, _rot, c_black, 1.0)
		gpu_set_blendenable(_gpu_state);
		
		for (var _i = self.total_layers-1; _i >= 0; _i--;) {
			var _v = self.data.layers[_i];
			
			if (is_undefined(self.content[$ _v.id]) && !_v.visible ) {
				continue;
			}
			
			#region // Axis Distortion Drawing
			surface_set_target(self.swap_textures.temp);
			draw_clear_alpha(c_black, 0);
			shader_set(sh_dieback_axis_distortion);
			
			// get true tpage size for main bg
			var _tpage = sprite_get_texture(self.content[$ _v.id][0], self.content[$ _v.id][1]);
			var _tpage_w = 1/texture_get_texel_width(_tpage);
			var _tpage_h = 1/texture_get_texel_height(_tpage);

			shader_set_uniform_i(self.axis_distortion_uniforms.tex_size, 
				_tpage_w,
				_tpage_h
			);
			
			var _t_uv = self.content_uv[$ _v.id];
			shader_set_uniform_f(self.axis_distortion_uniforms.tex_uvs, 
				_t_uv[0]*_tpage_w, _t_uv[1]*_tpage_h, _t_uv[2]*_tpage_w, _t_uv[3]*_tpage_h
			);

			var _real_offset = { x : -_v.offset.x, y : -_v.offset.y };
			if (_v.offset_mode == "Scrolling") {
				_real_offset.x = _time * -_v.offset.x;
				_real_offset.y = _time * -_v.offset.y;
			}

			shader_set_uniform_f(self.axis_distortion_uniforms.tex_offset, 
				_wrap(_real_offset.x, 0, sprite_get_width(self.content[$ _v.id][0])), 
				// feather ignore once GM2023
				_wrap(_real_offset.y, 0, sprite_get_height(self.content[$ _v.id][0]))
			);
				
			delete _real_offset;
			
			shader_set_uniform_i(self.axis_distortion_uniforms.axis_mode, _v.distortion.x - 1, _v.distortion.y - 1);
			shader_set_uniform_i(self.axis_distortion_uniforms.axis_frequency, _v.frequency.x, _v.frequency.y);
			shader_set_uniform_i(self.axis_distortion_uniforms.axis_amplitude, _v.amplitude.x, _v.amplitude.y);
			
			var _real_shift = { x : -_v.shift_offset.x, y : -_v.shift_offset.y };
			if (_v.shift_mode == "Scrolling") {
				_real_shift.x = _time * -_v.shift_offset.x;
				_real_shift.y = _time * -_v.shift_offset.y;
			}
			
			shader_set_uniform_f(self.axis_distortion_uniforms.axis_shift, 
				_wrap(_real_shift.x, 0, _v.frequency.x * 2), 
				// feather ignore once GM2023
				_wrap(_real_shift.y, 0, _v.frequency.y * 2)
			);
			
			delete _real_shift;
				
			shader_set_uniform_i(self.axis_distortion_uniforms.palette_enabled, _v.pal_used);

			if (!is_undefined(self.palettes[$ _v.id]) && _v.pal_used) {
				
				// feather ignore once GM2044
				var _tpage = sprite_get_texture(self.palettes[$ _v.id][0], self.palettes[$ _v.id][1]);
				// feather ignore once GM2044
				var _tpage_w = 1/texture_get_texel_width(_tpage);
				// feather ignore once GM2044
				var _tpage_h = 1/texture_get_texel_height(_tpage);

				shader_set_uniform_i(self.axis_distortion_uniforms.palette_size, 
					_tpage_w,
					_tpage_h
				);
				
				texture_set_stage(self.axis_distortion_uniforms.palette_texture, _tpage);
				
				var _p_uv = self.palettes_uv[$ _v.id]
				shader_set_uniform_f(self.axis_distortion_uniforms.palette_uvs, 
					_p_uv[0]*_tpage_w, _p_uv[1]*_tpage_h, _p_uv[2]*_tpage_w, _p_uv[3]*_tpage_h
				);
				
				var _real_palette = _v.pal_index;
				if (_v.pal_mode == "Cycling") {
					_real_palette = _time * _v.pal_index;
				}
				var _spr_h = sprite_get_height(self.palettes[$ _v.id][0]);
				var _index = _wrap(_real_palette, 0, _spr_h);
				shader_set_uniform_f(self.axis_distortion_uniforms.palette_index, _index);
			}
			
			// feather ignore once GM2044
			var _gpu_state = gpu_get_tex_repeat();
			gpu_set_tex_repeat(true);
			vertex_submit(self.quad, pr_trianglestrip, sprite_get_texture(self.content[$ _v.id][0], self.content[$ _v.id][1]));
			gpu_set_tex_repeat(_gpu_state);
		
			surface_reset_target();
			#endregion
				
			#region // Planar distortion & Blending
			surface_set_target(self.swap_textures.final);
			shader_set(sh_dieback_planar_distortion);
			
			shader_set_uniform_i(self.planar_distortion_uniforms.tex_size, self.data.dimensions.x, self.data.dimensions.y);
			shader_set_uniform_i(self.planar_distortion_uniforms.planar_mode, _v.plane_distort - 1);
			shader_set_uniform_f(self.planar_distortion_uniforms.planar_amplitude, _v.plane_amplitude);

				draw_clear_alpha(c_black, 0);
				
				draw_surface_ext(self.swap_textures.temp, 0, 0, 1, 1, 0, c_white, 1);
					
			shader_reset(); 
			surface_reset_target();
			
			if is_method(_v.blend_mode) {
				
				_v.blend_mode(self.swap_textures.final, _x, _y, _xscale, _yscale, _rot, _v.opacity);
			} else {
				var _pre_blend = gpu_get_blendmode();
				
				if (_v.blend_mode) < array_length(_blend_modes) {
					gpu_set_blendmode(_blend_modes[_v.blend_mode-1]);
				} 
				
				draw_surface_ext(self.swap_textures.final, _x, _y, _xscale, _yscale, _rot, c_white, _v.opacity);
				gpu_set_blendmode(_pre_blend);
			}
			
			#endregion
		}
			
		// No need to worry about this till after the above loop
	}
	
	///@function draw(x, y, blend_enable)
	///@desc Render and Draw the dieback background at a desired location.
	///@param {Real} x
	///@param {Real} y
	///@param {Bool} blend_enable
	static draw = function(_x, _y, _blend) {
		self.render(_x, _y, 1,1,0, _blend);
	}
	
	///@function draw_ext(x, y, xscale, yscale, rotation, color, alpha, blend_enable)
	///@desc Render and Draw the dieback background at a desired location.
	///@param {Real} x
	///@param {Real} y
	///@param {Real} xscale
	///@param {Real} yscale
	///@param {Real} rotation
	///@param {Bool} blend_enable
	static draw_ext = function(_x, _y, _xscale, _yscale, _rot, _blend) {
		self.render(_x, _y, _xscale, _yscale, _rot, _blend);
	}
	
	///@function free()
	///@desc Clean all assets that aren't Garbage Collected.
	static free = function() {
		// I really wish gamemaker had GC callbacks... instead of some freaky manual mem and gc freakshow...
		surface_free(self.swap_textures.temp);
		surface_free(self.swap_textures.final);
		self.swap_textures.temp = undefined;
		self.swap_textures.final = undefined;
		
		vertex_delete_buffer(self.quad);
		self.quad = undefined;
		vertex_format_delete(self.quad_format);
		self.quad_format = undefined;
		
		for (var _i = 0; _i < self.total_layers; _i++;) {
			var _v = self.data.layers[_i];
			
			if (_v.back_data == "free") {
				sprite_delete(self.content[$ _v.id][0]);
				self.content[$ _v.id] = undefined;
			}
			
			if (_v.pal_data == "free") {
				sprite_delete(self.palettes[$ _v.id][0]);
				self.palettes[$ _v.id] = undefined;
			}
		}
	}
	
}

///@function dieback_load_dbi(filepath)
///@desc Load a background from a .dbi file.
///@param {String} filepath
///@return {Struct.DiebackInst}
function dieback_load_dbi(_file_path) {
	var _compressed_buffer = buffer_load(_file_path);
	var _decompressed_buffer = buffer_decompress(_compressed_buffer);
	var _buffer_string = buffer_read(_decompressed_buffer, buffer_string);
		
	buffer_delete(_compressed_buffer);
	buffer_delete(_decompressed_buffer);
	
	var _inst = new DiebackInst();
	_inst.load(json_parse(_buffer_string));
	
	//show_debug_message(json_parse(_buffer_string));
	
	return _inst;
}

/// DIEBACK GENERATOR

enum DIEBACK_BLENDMODE {
	NORMAL = 1,
	ADD,
	SUBTRACT,
	SCREEN,
	CUSTOM,
};

enum DIEBACK_MOTION {
	STATIC,
	INDEXED,
	SCROLLING,
	CYCLING
};

enum DIEBACK_DISTORTION {
	OSCILLATION = 1,
	INTERLACED,
	COMPRESSION
};

enum DIEBACK_AXIS {
	X,
	Y
};

///@function dieback_data_gen(width, height)
///@desc Create an empty background with functions to construct background data. Pass to [background].load to get a background!
///@param {Real} width
///@param {Real} height
function DiebackDataGen(_w, _h) constructor {
	
	dimensions = {
		x : _w,
		y : _h
	};
	layers = [];
	current_layer = 0;
	
	///@function n_layer(sprite, index, opacity)
	///@desc Create a new layer with a given sprite, index, and opacity.
	///@param {Asset.GMSprite} sprite
	///@param {Real} index
	///@param {Real} opacity
	static n_layer = function(_sprite, _index, _opacity) {
		self.current_layer = array_length(self.layers);
		var _layer = {
			id : array_length(self.layers)+1,
			visible : true,
			title : "layer"+string(self.current_layer), // doesn't matter, more of a utility for dieback...
			
			pal_data : "",
			pal_used : false,
			pal_index : 0,
			pal_mode : "Indexed",
			callback : undefined,
			
			back_data : [_sprite, _index],
			opacity : _opacity,
			offset : { x : 0, y : 0 },
			offset_mode : "Static",
	
			distortion : { x : 1, y : 1 },
			frequency : { x : 0, y : 0 },
			amplitude : { x : 0, y : 0 },
			shift_offset : { x : 0, y : 0 },
			shift_mode : "Static",
	
			plane_distort : 1,
			plane_amplitude : 0,
			blend_mode : DIEBACK_BLENDMODE.NORMAL,
		};
		
		self.layers[ self.current_layer ] = _layer;
		
		return self; // allow chaining
	}
	
	///@function s_background_position(x, y, motion_type)
	///@desc Set the background position and or scroll speed.
	///@param {Real} x speed or position
	///@param {Real} y speed or position
	///@param {Enum.DIEBACK_MOTION} motion_type
	static s_background_position = function(_x, _y, _motion) {
		
		var _layer = self.layers[self.current_layer];
		
		_layer.offset.x = _x;
		_layer.offset.y = _y;
		_layer.offset_mode = (_motion == DIEBACK_MOTION.SCROLLING ? "Scrolling" : "Static");
		
		return self;
	};
	
	///@function s_palette(sprite, index, motion_type, pal_index)
	///@desc Enable and load a palette for the current layer, as well as Indexed or Cycling with a speed.
	///@param {Asset.GMSprite} sprite
	///@param {Real} index
	///@param {Enum.DIEBACK_MOTION} motion_type
	///@param {Real} pal_index speed or position
	static s_palette = function(_sprite, _index, _motion, _pal_val) {
		
		var _layer = self.layers[self.current_layer];
		
		_layer.pal_data = [_sprite, _index];
		_layer.pal_used = true;
		_layer.pal_mode = (_motion == DIEBACK_MOTION.CYCLING ? "Cycling" : "Indexed");
		_layer.pal_index = _pal_val;
		
		return self;
	};
	
	///@function s_axis_distortion(axis, distortion, frequency, amplitude);
	///@desc Set the axis distortion mode for the background.
	///@param {Enum.DIEBACK_AXIS} axis
	///@param {Enum.DIEBACK_DISTORTION} distortion
	///@param {Real} frequency
	///@param {Real} amplitude
	static s_axis_distortion = function(_axis, _distortion, _frequency, _amplitude) {
		
		var _accessor = "x";
		
		if _axis == DIEBACK_AXIS.Y {
			// feather ignore once GM2044
			var _accessor = "y";
		}
		
		var _layer = self.layers[self.current_layer];
		
		_layer.distortion[$ _accessor] = _distortion;
		_layer.frequency[$ _accessor] = _frequency;
		_layer.amplitude[$ _accessor] = _amplitude;
		
		return self
	};
	
	///@function s_axis_motion(x, y, motion_type)
	///@desc Set the axis motion, ie apply a motion or offset to the distortion effect.
	///@param {Real} x speed or position
	///@param {Real} y speed or position
	///@param {Enum.DIEBACK_MOTION} motion_type
	static s_axis_motion = function(_x, _y, _motion) {
		
		var _layer = self.layers[self.current_layer];
		
		_layer.shift_mode = (_motion == DIEBACK_MOTION.SCROLLING ? "Scrolling" : "Static");
		_layer.shift_offset.x = _x;
		_layer.shift_offset.y = _y;
		
		return self;
	};
	
	///@function s_planar(amplitude)
	///@desc Set the planar distortion, ie fishbowl.
	///@param {Real} amplitude
	static s_planar = function(_amplitude) {
		
		var _layer = self.layers[self.current_layer];
		
		_layer.plane_amplitude = _amplitude;
		
		return self;
	};
		
	///@function s_script(function);
	///@desc Set the script function for this layer.
	///@param {Function} function
	static s_script = function(_function) {
		
		var _layer = self.layers[self.current_layer];
		
		_layer.callback = _function;
		
		return self;
	};
	
	///@function s_script(blendmode, function);
	///@desc Set the script function for this layer.
	///@param {Enum.DIEBACK_BLENDMODE} blendmode
	///@param [Function] function
	static s_blend = function(_blendmode, _function) {
		
		var _layer = self.layers[self.current_layer];
		
		_layer.blend_mode = _blendmode;
		
		if (_blendmode == DIEBACK_BLENDMODE.CUSTOM && is_method(_function)) {
			_layer.blend_mode = _function;
			
		}
		
		return self;
	};
	
	///@function flip();
	///@desc Flips the layer, Dieback renders in reverse order but that makes less sense code wise so here is a nice utility.
	static flip = function() {
		// The below is not illegal!
		// feather ignore once GM1041
		self.layers = array_reverse(self.layers);
	}
}

// feather enable GM1042