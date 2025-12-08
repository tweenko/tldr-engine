// --------- CAMERA STUFF -------------
function guipos_x() {
	return camera_get_view_x(view_camera[0])
}
function guipos_y() {
	return camera_get_view_y(view_camera[0])
}

///@desc Used to check if an instance is on the screen.
///@arg {Id.Instance|Asset.GMObject} [instance]
///@arg {Real} [tolerance]
/// @return {Bool}
function onscreen(instance = id, tolerance = 0) {	
    if !instance_exists(instance)
        exit
    
    if instance.x + instance.sprite_width + tolerance < guipos_x() 
        || instance.x - tolerance > guipos_x() + 640
        || instance.y + instance.sprite_height + tolerance < guipos_y() 
        || instance.y - tolerance > guipos_y() + 480
        return false
    else
        return true
}

///@desc shakes the screen (with the gui layer) and returns the animation used
///@return {Struct.__anime_class}
function screen_shake(pow, timelen = undefined){
	timelen ??= pow * 2
	return animate(pow, 0, timelen, "linear", o_window, "shake")
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
        o_camera.animation_x = animate(o_camera.x, x_dest, time, ease_type, o_camera, "x")
    if o_camera.y != y_dest && !is_undefined(y_dest)
        o_camera.animation_y = animate(o_camera.y, y_dest, time, ease_type, o_camera, "y")
}
function camera_unpan(target, time, ease_type = "linear") {
    o_camera.target = target
    
    o_camera.offset_x = guipos_x() - camera_confine_x(target.x)
    o_camera.offset_y = guipos_y() - camera_confine_y(target.y)
    
    camera_stop_animations()
    
    o_camera.animation_x = animate(o_camera.offset_x, 0, time, ease_type, o_camera, "offset_x")
    o_camera.animation_y = animate(o_camera.offset_y, 0, time, ease_type, o_camera, "offset_y")
}
function camera_stop_animations() {
    if is_struct(o_camera.animation_x)
        o_camera.animation_x._stop()
    if is_struct(o_camera.animation_y)
        o_camera.animation_y._stop()
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


// --------- SOUND STUFF -------------
enum AUDIO {
    SOUND,
    MUSIC
}

///@arg {Enum.AUDIO} type the type of sound you want to get the volume of. Either AUDIO.SOUND or AUDIO.MUSIC
function volume_get(type){
	if type == AUDIO.SOUND
		return o_world.volume_sfx * o_world.volume_master
    if type == AUDIO.MUSIC
		return o_world.volume_bgm * o_world.volume_master
    
	return 0
}

/**
 * sort of just **audio_play_sound** with some extra functionality, like:
 * - auto gain adjustment depending on set volume
 * - an option to make the sounds not stack on top of each other when playing on the same frame
 * - way to control whether the played audio is a sound or music
 * @param {asset} sound the sound to play
 * @param {real} [loop] whether the sound should loop after it finishes
 * @param {real} [gain] the gain of the sound played. will be automatically mulitplied by the volume of the sound type
 * @param {real} [pitch] the pitch of the sound played. 
 * @param {bool} [nonstack] whether the sound should not stack if played on the same frame twice
 * @param {enum.AUDIO} [type] the type of the sound
 * @returns {id.Sound}
 */
function audio_play(sound, loop = 0, gain = 1, pitch = 1, nonstack = false, type = AUDIO.SOUND) {
	var ret = -1
    var target_emitter = noone
    
    if nonstack && o_world.sound_on_frame == sound // exit if you're we are avoiding sound stacking
        return undefined
    
    switch type {
        case AUDIO.SOUND:
            target_emitter = o_world.emitter_sfx;
            break
        case AUDIO.MUSIC:
            target_emitter = o_world.emitter_music
            break
    }
    
    ret = audio_play_sound_on(target_emitter, 
        sound, loop, 
        0, volume_get(type) * gain,
        0, pitch
    )
    o_world.sound_on_frame = sound
	
    return ret
}

///@desc Creates a loaded stream of audio straight from "locale/sfx/..."
function audio_create_loaded(name, ext = ".ogg") {
	variable_instance_set(id, name, audio_create_stream(string("locale/sfx/{0}{1}", name, ext)))
}
function audio_sound_set_effect(effect, slot = 0){
	o_world.bus_sfx.effects[slot] = effect;
}
function audio_sound_get_effect(slot = 0){
	return o_world.bus_sfx.effects[slot]
}
function audio_sound_reset_effect(slot = 0){
	o_world.bus_sfx.effects[slot] = undefined;
}


// ---------------- DRAWING STUFF -------------
/**
 * draws text while stretching it to make it fit inside some x width
 * @param {real} xx the x position of where to draw the text
 * @param {real} yy the x position of where to draw the text
 * @param {any} str the text
 * @param {real} xfit the x width where you would need to fit the text in
 * @param {real} xscale the x scale of the desired string (the preferred one)
 * @param {real} yscale the y scale of the desired string
 */
function draw_text_xfit(xx, yy, str, xfit, xscale, yscale) {
	draw_text_transformed(xx, yy, str, min(xscale, xfit / (string_width(str)*xscale)), yscale, 0)
}

function draw_rectangle_ext(x1, y1, x2, y2, color, outline_width) {
	for (var i = 0; i < outline_width; i += 1) {
	    draw_rectangle_color(x1+i, y1+i, x2-i, y2-i, color, color, color, color, true)
	}
}
function draw_sprite_looped(offset, amp, sprite, image, xx, yy, xscale = 1, yscale = 1, angle = 0, color = c_white, alpha = 1, move_x = true, move_y = true, xamt = 2, yamt = 2) {
	var __sw = sprite_get_width(sprite)  * xscale
	var __sh = sprite_get_height(sprite) * yscale
    
	// pixel–space offsets (smooth, always positive)
	var __ox = (move_x ? (offset * amp) mod __sw : 0)
	var __oy = (move_y ? (offset * amp) mod __sh : 0)

	for (var i = 0; abs(i) < xamt; i += sign(amp) ) {
	    for (var j = 0; abs(j) < yamt; j += sign(amp)) {
	        draw_sprite_ext(
	            sprite, image,
		        xx - __ox + i * __sw,
	            yy - __oy + j * __sh,
	            xscale, yscale, angle, color, alpha
	        )
	    }
	}
}


/// ------------- INSTANCE AND OBJECT STUFF --------------

/// @desc uses post_var_struct instead of just var_struct because it sets the values in the struct after the instance's create event has run.
function instance_create(obj, xx = 0, yy = 0, dpth = 0, post_var_struct = {}) {
	var instance = instance_create_depth(xx, yy, dpth, obj);
	if post_var_struct != {}{
		var struct_names = struct_get_names(post_var_struct)
		for (var i = 0; i < struct_names_count(post_var_struct); ++i) {
		    if variable_instance_exists(instance, struct_names[i]) 
				variable_instance_set(instance, struct_names[i], struct_get(post_var_struct, struct_names[i]))
		}
	}
	return instance
}
function instance_clean(inst) {
	if instance_exists(inst){
		instance_destroy(inst)
	}
}
/// @desc	same as instance_place_list but returns the ds list
function instance_place_list_ext(xx, yy, obj, ordered){
	var m = ds_list_create()
	ds_list_clear(m)
    
	instance_place_list(xx, yy, obj, m, ordered)
	
    var a = []
	for (var i = 0; i < ds_list_size(m); ++i) {
	    array_push(a, m[|i])
	}
	ds_list_destroy(m)
	return a
}
/// @param {Id.Instance|Asset.GMObject} o_index
/// @param {Asset.GMObject} stop_at
/// @desc Return the base parent object index, or noone if invalid.
function object_get_base_parent(o_index, stop_at = noone) {
    var current_object = o_index;
    while (object_get_parent(current_object) != -100&&current_object!=stop_at) {
        current_object = object_get_parent(current_object);
    }
    return current_object;
}

/// @desc returns an asset index with specified name but if the prefix version does not exists, returns the normal sprite
function asset_get_index_state(str, state){
	var ret = asset_get_index(str)
    var __states = string_split(state, "_", true)
	
	for (var i = array_length(__states); i >= 0; i--) {
        var __curstate = ""
        for (var j = 0; j < i; j ++) {
            __curstate += __states[j]
            if j < i - 1
                __curstate += "_"
        }
        if __curstate != ""
            __curstate = string_concat("_", __curstate)
        
		var r = asset_get_index(str + __curstate)
		if r != -1 {
			ret = r
			break
		}
	}
    
	return ret
}


// ------------ DATA TYPE STUFF -----------------
/**
 * inserts a value into an array while making its size the same, 
 * AKA deleting the last item in the array before inserting the new one
 * @param {array<any*>} array the array in which you need to insert a variable into
 * @param {real} index the index of the place you want to insert the item into
 * @param {any*} val the value you want to insert
 */
function array_insert_cycle(array, index, val) {
	array_resize(array, array_length(array) - 1);
	array_insert(array, index, val);
}
/// @desc literally copies the array, not creating a direct link
function array_clone(array){
	var ret = []
	array_copy(ret, 0, array, 0, array_length(array))
	return ret
}
///@desc	Sort an array, but this ext version returns the array back.
///@arg		array
///@arg		{function|bool}	sorttype_or_function True for ascending and False for descending or a function reference for sorting.
///@return	{array}
function array_sort_ext(array, sort_type_or_function) {
	var arr = array_clone(array)
	array_sort(arr, sort_type_or_function)
	return arr
}
/// @param {string}  substring  The string to find.
/// @param {string}  fullstring  The string to find from.
/// @description              Check if a string contains a string inside it.

function string_contains(substring, fullString) {
    return string_pos(substring, fullString) > 0;
}

/// @desc	rounds value with cerain percision
/// @arg	{real} value
/// @arg	{real} precision    works like round(value/precision) * precision
function round_p(value, precision){
	return round(value/precision) * precision
}

/// @desc Recursively clones a struct or array
function deep_clone(src) {
    if is_array(src) {
        var new_arr = array_create(array_length(src));
        for (var i = 0; i < array_length(src); i++) {
            new_arr[i] = deep_clone(src[i]);
        }
        return new_arr;
    }
    else if is_struct(src) {
        var new_struct = {};
        var keys = variable_struct_get_names(src);
        for (var i = 0; i < array_length(keys); i++) {
            var key = keys[i];
            var val = struct_get(src, key);

            // Only clone if it's cloneable
            if (is_array(val) || is_struct(val)) {
                struct_set(new_struct, key, deep_clone(val))
            } 
			else {
				struct_set(new_struct, key, val)
            }
        }
        return new_struct;
    }
    else {
        return src;
    }
}
/// @desc merge two structs. created by u/MD__Wade
function struct_merge(primary, secondary, shared) {
	var _ReturnStruct = primary;
	
	if (shared)	{
		var _PropertyNames = variable_struct_get_names(primary);
		for (var i = 0; i < array_length(_PropertyNames); i ++)	{
			if (variable_struct_exists(secondary, _PropertyNames[i]))	{
				variable_struct_set(_ReturnStruct, _PropertyNames[i], variable_struct_get(secondary, _PropertyNames[i]));
			}
		}
	}	else	{
		var _PropertyNames = variable_struct_get_names(secondary);
		for (var i = 0; i < array_length(_PropertyNames); i ++)	{
			variable_struct_set(_ReturnStruct, _PropertyNames[i], variable_struct_get(secondary, _PropertyNames[i]));
		}
	}
	return _ReturnStruct;
}


// ------------ MISC FUNTIONS ---------------------
function sine(INP_DEVIDE, OUT_MULTIPLY, input = undefined) {
	var sine_output = 0
	if is_undefined(input)
		sine_output = sin(o_world.frames/INP_DEVIDE) * OUT_MULTIPLY
	else
		sine_output = sin(input/INP_DEVIDE) * OUT_MULTIPLY
	return sine_output
}
function cosine(INP_DEVIDE, OUT_MULTIPLY, input = undefined) {
	var sine_output = 0
	if is_undefined(input)
		sine_output = cos(o_world.frames/INP_DEVIDE) * OUT_MULTIPLY
	else
		sine_output = cos(input/INP_DEVIDE) * OUT_MULTIPLY
	return sine_output
}

///@desc makes a black fade
///@arg {real}	start
///@arg {real}	end
///@arg {real}	time
function fader_fade(a, b, time){
	if !instance_exists(o_fader)
        return false
    
    if time == 0
        o_fader.image_alpha = b
    else 
        animate(a, b, time, "linear", o_fader, "image_alpha")
}
///@desc starts a flash animation, color of which you can change
///@arg {real}	start
///@arg {real}	end
///@arg {real}	time
function flash_fade(a, b, time, color = c_white){
	if !instance_exists(o_flash)
        return false
    
    o_flash.color = color
    if time == 0
        o_flash.image_alpha = b
    else 
        animate(a, b, time, "linear", o_flash, "image_alpha")
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

///@desc returns time in the format of HH:MM:SS (hours can overflow)
///@arg {bool} [display_hours] if asked not to, it will return the MM:SS format instead
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


// ----------- INPUT STUFF --------------------
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