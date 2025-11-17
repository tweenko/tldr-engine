function string_to_color(color_string){
	switch color_string{
		case "c_red":
		case "r":
			return c_red
		case "c_blue":
		case "b":
			return c_blue
		case "c_yellow":
		case "y":
			return c_yellow
		case "c_lime":
		case "g":
			return c_lime
		case "c_black":
			return c_black
		case "c_dkgray":
			return c_dkgray
		case "c_gray":
			return c_gray
		case "c_silver":
			return c_silver
        case "c_orange":
            return c_orange
		default:
			return c_white
	}
}
function color_to_string(color){
	var cc = merge_color(c_aqua, c_blue, 0.3)
    
	switch color {
		case c_red:
			return "c_red"
		case c_blue:
			return "c_blue"
		case c_green:
			return "c_green"
		case c_yellow:
			return "c_yellow"
		case c_lime:
			return "c_lime"
		case c_black:
			return "c_black"
		case cc:
			return "tired_aqua"
		default:
			return "c_white"
	}
}

///@desc shakes the screen (with the gui layer)
function screen_shake(pow, timelen = undefined){
	if timelen == undefined
        timelen = pow * 2
	do_anime(pow, 0, timelen, "linear", function(v){
        if instance_exists(o_window) 
            o_window.shake = v
    })
}

///@desc creates a trail of the object that calls this function
function afterimage(_decay_speed = 0.1, inst = id, gui = false, drawer = undefined){
    var _afterimage = instance_create_depth(inst.x, inst.y, inst.depth, o_afterimage)

    _afterimage.sprite_index = inst.sprite_index
    _afterimage.image_index = inst.image_index
    _afterimage.image_blend = inst.image_blend
    _afterimage.image_speed = 0
    _afterimage.depth = inst.depth
    _afterimage.gui = gui
    _afterimage.image_xscale = inst.image_xscale
    _afterimage.image_yscale = inst.image_yscale
    _afterimage.image_angle = inst.image_angle
    _afterimage.decay_speed = _decay_speed
    
    if !is_undefined(drawer) && is_callable(drawer)
        _afterimage.drawer = drawer

    return _afterimage;
}

///@desc draws the deltarune dialogue box
function ui_dialoguebox_create(xx, yy, width, height, world = global.world){
	var frame = (o_world.frames/10) % 8
	if world == WORLD_TYPE.DARK {
		draw_sprite_ext(spr_pixel, 0, xx + 12, yy + 12, width - 24, height - 24, 0, c_black, 1);
        
		draw_sprite_ext(spr_ui_dkbox_top, 0, xx + 16, yy, width - 32, 2, 0, c_white, 1)
		draw_sprite_ext(spr_ui_dkbox_top, 0, xx + 16, yy + height, width - 32, -2, 0, c_white, 1)
		draw_sprite_ext(spr_ui_dkbox_left, 0, xx, yy + 16, 2, height - 32, 0, c_white, 1)
		draw_sprite_ext(spr_ui_dkbox_left, 0, xx + width, yy + 16, -2, height - 32, 0, c_white, 1)
        
		draw_sprite_ext(spr_ui_dkbox_corner, frame, xx, yy, 2, 2, 0, c_white, 1)
		draw_sprite_ext(spr_ui_dkbox_corner, frame, xx + width, yy, -2, 2, 0, c_white, 1)
		draw_sprite_ext(spr_ui_dkbox_corner, frame, xx, yy + height, 2, -2, 0, c_white, 1)
		draw_sprite_ext(spr_ui_dkbox_corner, frame, xx + width, yy + height, -2, -2, 0, c_white, 1)
	}
	else {
		draw_sprite_ext(spr_pixel, 0, xx, yy, width, height, 0, c_white, 1);
		draw_sprite_ext(spr_pixel, 0, xx + 6, yy + 6, width - 12, height - 12, 0, c_black, 1);
	}
}



///@desc returns time in the format of HH:MM:SS (hours can overflow)
///@arg {bool} display_hours if asked not to, it will return the MM:SS format instead
function time_format(time_s, display_hours = true){
	time_s = round(time_s)
    
	var time_m = floor(time_s/60)
	var time_h = floor(time_m/60)
	time_m -= time_h*60
	
	time_s -= time_m * 60
	time_s -= time_h * 60*60
	
	if time_m < 10 {
		time_m = $"0{time_m}"
	}
	if time_s < 10 {
		time_s = $"0{time_s}"
	}
	
	var time = $"{time_h}:{time_m}:{time_s}"
	if !display_hours 
		time = $"{time_m}:{time_s}"
	
	return time
}

/// @desc converts binds to keys
function input_binding_to_string(bind, upper = true, _is_gamepad = InputDeviceIsGamepad(InputPlayerGetDevice())){
	var __bindname = InputGetBindingName(bind, _is_gamepad)
    var __ret = ""
    
    if string_contains("arrow", __bindname) {
        __ret = string_split(__bindname, " ")[1]
        __ret = string_upper(string_copy(__ret, 1, 1)) + string_delete(__ret, 1, 1);
    }
    else {
    	__ret = string_upper(__bindname)
    }
    
	return (upper ? string_upper(__ret) : __ret)
}
/// @desc converts a bind to text (or sprite) - gets it ready for use in dialogue
function input_binding_intext(verb) {
	if InputPlayerUsingGamepad() {
		if is_array(verb) {
			var res = ""
			for (var i = 0; i < array_length(verb); ++i) {
				res += "{spr(" + sprite_get_name(InputIconGet(verb[i])) + ")}"
			}
			return res
		}
		else 
			return "{spr(" + sprite_get_name(InputIconGet(verb)) + ")}"
	}
	if is_array(verb){
		var res = ""
		for (var i = 0; i < array_length(verb); ++i) {
			res += input_binding_to_string(InputBindingGet(false, verb[i])) + "/"
		}
		res = string_delete(res, string_width(res)-1, 1)
		
		return $"[{res}]"
	}
	
	return $"[{input_binding_to_string(InputBindingGet(false, verb))}]"
}

/// @desc converts a bind to text (or sprite) - gets it ready for use in dialogue
function input_binding_draw(verb, xx, yy, scale, label = "", pre_label = "", _is_gamepad = InputDeviceIsGamepad(InputPlayerGetDevice())) {
	if _is_gamepad {
        draw_text_transformed(xx, yy, pre_label, scale, scale, 0)
        xx += string_width(pre_label) * scale
        
		if is_array(verb) {
			for (var i = 0; i < array_length(verb); ++i) {
                draw_sprite_ext(InputIconGet(verb[i]), 0, xx, yy-scale + 2.5*scale, scale, scale, 0, c_white, 1)
                xx += sprite_get_width(InputIconGet(verb[i])) * scale
			}
		}
		else {
            draw_sprite_ext(InputIconGet(verb), 0, xx, yy-scale + 2.5*scale, scale, scale, 0, c_white, 1)
            xx += sprite_get_width(InputIconGet(verb)) * scale
        }
        draw_text_transformed(xx, yy, label, scale, scale, 0)
        
        return true
	}
    
	if is_array(verb) {
		var res = ""
		for (var i = 0; i < array_length(verb); ++i) {
			res += input_binding_to_string(InputBindingGet(false, verb[i]), true, _is_gamepad) + "/"
		}
		res = string_delete(res, string_width(res)-1, 1)
		
        draw_text_transformed(xx, yy, pre_label + $"[{res}]" + label, scale, scale, 0)
        return true
	}
	
    draw_text_transformed(xx, yy, pre_label + $"[{input_binding_to_string(InputBindingGet(false, verb), true, _is_gamepad)}]" + label, scale, scale, 0)
}

/// @ignore
/// @desc ripped from deltarune code. don't use this.
/// @param {real} alpha - The alpha transparency of the tiles (0 to 1).
function draw_sprite_tiled_area(sprite, subimg, xx, yy, x1, y1, x2, y2, xscale, yscale, blend, alpha) {
    var sw = sprite_get_width(sprite) * xscale;
    var sh = sprite_get_height(sprite) * yscale;

    // Normalize offsets
    var start_x = x1 - ((x1 - xx) % sw);
    var start_y = y1 - ((y1 - yy) % sh);

    for (var i = start_x; i < x2; i += sw) {
        for (var j = start_y; j < y2; j += sh) {
            var left = 0;
            var top = 0;
            var width = sw;
            var height = sh;

            // Clip left edge
            if (i < x1) {
                left = (x1 - i) / xscale;
                width -= (x1 - i);
            }
            if (j < y1) {
                top = (y1 - j) / yscale;
                height -= (y1 - j);
            }

            // Clip right edge
            if (i + width > x2) {
                width -= (i + width - x2);
            }
            if (j + height > y2) {
                height -= (j + height - y2);
            }

            draw_sprite_part_ext(sprite, subimg, left, top, width / xscale, height / yscale, i + left * xscale, j + top * yscale, xscale, yscale, blend, alpha);
        }
    }
}
/// @ignore
/// @desc ripped from deltarune code. don't use this.
function draw_sprite_part_parallax(sprite, image, xoff, yoff, alpha, xx = x, yy = y){
    var _mywidth = sprite_get_width(sprite)
    var _myheight = sprite_get_height(sprite)
	
    var _xoffset = xoff%_mywidth
    var _yoffset = yoff%_myheight
	
    if _xoffset<0 _xoffset+=_mywidth
    if _yoffset<0 _yoffset+=_myheight
	
    if _xoffset==0 && _yoffset==0
        draw_sprite_ext(sprite, image, xx, yy, 1, 1, 0, image_blend, alpha)
    else{
        draw_sprite_part_ext(sprite, image, 0, 0, (_mywidth - _xoffset), (_myheight - _yoffset), (xx + _xoffset), (yy + _yoffset), 1,1, image_blend, alpha)
        draw_sprite_part_ext(sprite, image, (_mywidth - _xoffset), (_myheight - _yoffset), _xoffset, _yoffset, xx, yy, 1, 1, image_blend, alpha)
        draw_sprite_part_ext(sprite, image, 0, (_myheight - _yoffset), (_mywidth - _xoffset), _yoffset, (xx + _xoffset), yy,1,1, image_blend, alpha)
        draw_sprite_part_ext(sprite, image, (_mywidth - _xoffset), 0, _xoffset, (_myheight - _yoffset), xx, (yy + _yoffset), 1,1, image_blend, alpha)
    }
}
/// @ignore
/// @desc ripped from deltarune code. don't use this.
function draw_sprite_part_parallax_scale(sprite, image, xoff, yoff, alpha, scale, xx = x,yy = y, xmax = -1, ymax = -1){
    var _mywidth = sprite_get_width(sprite)
    var _myheight = sprite_get_height(sprite)
	
    var _xoffset = xoff%_mywidth
    var _yoffset = yoff%_myheight
	
    if _xoffset<0 _xoffset+=_mywidth
    if _yoffset<0 _yoffset+=_myheight
	
    var _xmax = (xmax==-1 ? _mywidth * scale : xmax)
    var _ymax = (ymax==-1 ? _myheight * scale : ymax)
	
    if _xoffset==0 && _yoffset==0
        draw_sprite_ext(sprite, image, xx, yy, 1, 1, 0, image_blend, alpha)
    else{
        draw_sprite_part_ext(sprite, image, 0, 0, (_xmax - _xoffset), (_ymax - _yoffset), (xx + _xoffset * scale), (yy + _yoffset * scale), scale, scale, image_blend, alpha)
        draw_sprite_part_ext(sprite, image, (_mywidth - _xoffset), (_myheight - _yoffset), min(_xmax, _xoffset), min(_ymax, _yoffset), xx, yy, scale, scale, image_blend, alpha)
        draw_sprite_part_ext(sprite, image, 0, (_ymax - _yoffset), min(_xmax, (_xmax - _xoffset)), min(_ymax, _yoffset), (xx + _xoffset * scale), yy, scale, scale, image_blend, alpha)
        draw_sprite_part_ext(sprite, image, (_xmax - _xoffset), 0, min(_xmax, _xoffset), min(_ymax, (_ymax - _yoffset)), xx, (yy + _yoffset * scale), scale, scale, image_blend, alpha)
    }
}

function camera_confine_x(xx) {
    xx = xx - o_camera.width/2
    xx = clamp(xx, 0, room_width - o_camera.width)
    
    return xx
}
function camera_confine_y(yy) {
    yy = yy - o_camera.height/2
    yy = clamp(yy, 0, room_height - o_camera.height)
    
    return yy
}

/// @desc pan the camera using two animation instances
/// @param {real} x_dest  set to undefined if you don't want to move on this axis
/// @param {real} y_dest  set to undefined if you don't want to move on this axis
/// @param {real} time the amount of time the camera will take to fully animate
/// @param {string} [ease_type] the ease type the animation will use, look in lerp_type script to find the full list
/// @param {bool} [confined_x] whether the camera is confined within the bounds of the room on the x axis (true by default)
/// @param {bool} [confined_y] whether the camera is confined within the bounds of the room on the y axis (true by default)
function camera_pan(x_dest, y_dest, time, ease_type = "linear", confined_x = true, confined_y = true) {
    x_dest ??= o_camera.x
    y_dest ??= o_camera.y
    
    if confined_x
        x_dest = camera_confine_x(x_dest)
    if confined_y
        y_dest = camera_confine_y(y_dest)
    
    camera_stop_animations()
    
    if o_camera.x != x_dest && !is_undefined(x_dest)
        o_camera.animation_x = do_animate(o_camera.x, x_dest, time, ease_type, o_camera, "x")
    if o_camera.y != y_dest && !is_undefined(y_dest)
        o_camera.animation_y = do_animate(o_camera.y, y_dest, time, ease_type, o_camera, "y")
}
function camera_unpan(target, time, ease_type = "linear") {
    o_camera.target = target
    
    o_camera.offset_x = guipos_x() - camera_confine_x(target.x)
    o_camera.offset_y = guipos_y() - camera_confine_y(target.y)
    
    camera_stop_animations()
    
    o_camera.animation_x = do_animate(o_camera.offset_x, 0, time, ease_type, o_camera, "offset_x")
    o_camera.animation_y = do_animate(o_camera.offset_y, 0, time, ease_type, o_camera, "offset_y")
}

function camera_stop_animations() {
    if is_struct(o_camera.animation_x)
        o_camera.animation_x.stop()
    if is_struct(o_camera.animation_y)
        o_camera.animation_y.stop()
}

function convert_leader_equipment() {
    var __weapon = party_getdata(global.party_names[0], "weapon")
    if !is_undefined(__weapon)
        global.lw_weapon = __weapon.lw_counterpart
    
    var __armor1 = party_getdata(global.party_names[0], "armor1")
    if !is_undefined(__armor1)
        global.lw_armor = __armor1.lw_counterpart
    var __armor2 = party_getdata(global.party_names[0], "armor2")
    if !is_undefined(__armor2) && !is_undefined(__armor2.lw_counterpart)
        global.lw_armor = __armor2.lw_counterpart
    
    if !is_undefined(global.lw_weapon) && is_callable(global.lw_weapon)
        global.lw_weapon = new global.lw_weapon()
    if !is_undefined(global.lw_armor) && is_callable(global.lw_armor)
        global.lw_armor = new global.lw_armor()
}

function world_switch(world) {
    var wprevious = global.world
    global.world = world
    
    if wprevious != global.world
        convert_leader_equipment()
}