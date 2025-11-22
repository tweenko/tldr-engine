function guipos_x() {
	return camera_get_view_x(view_camera[0])
}
function guipos_y() {
	return camera_get_view_y(view_camera[0])
}

///@desc Used to check if an instance is on the screen.
///@arg {Id.Instance|Asset.GMObject} instance
///@arg {Real} tolerance
function onscreen(instance = id, tolerance=0)
{	if !instance_exists(instance){exit}
    if (((instance.x + instance.sprite_width) + tolerance) < guipos_x() || (instance.x - tolerance) > (guipos_x() + 640) || ((instance.y + instance.sprite_height) + tolerance) < guipos_y() || (instance.y - tolerance) > (guipos_y() + 480))
        return 0;
    else
        return 1;
}

enum AUDIO {
    SOUND,
    MUSIC
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
	if type == AUDIO.SOUND {
		if nonstack {
			if o_world.sound_on_frame != sound {
				ret = audio_play_sound_on(o_world.emitter_sfx, 
                    sound, loop, 
                    0, volume_get(type) * gain,
                    0, pitch
                )
				o_world.sound_on_frame = sound
			}
            else
				ret = -1
		}
        else {
			ret = audio_play_sound_on(o_world.emitter_sfx, 
                sound, loop, 
                0, volume_get(type) * gain,
                0, pitch
            )
		}
	}
	else {
		if nonstack {
			if o_world.sound_on_frame != sound {
				ret = audio_play_sound_on(o_world.emitter_music, 
                    sound, loop, 0, 
                    gain, 
                    0, pitch
                )
				o_world.sound_on_frame = sound
			}
            else
				ret = -1
		}
        else {
			ret = audio_play_sound_on(o_world.emitter_music, 
                sound, loop, 
                0, gain, 
                0, pitch
            )
		}
	}
	
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
function draw_text_scale(_string = "", _x = 0, _y = 0, _scale = 2, _col = c_white, _alp = 1) {
	draw_text_transformed_color(_x, _y, _string, _scale, _scale, 0, _col, _col, _col, _col, _alp)
}
///@desc	text_transformed but with a shadow
///@arg	{real}		x
///@arg	{real}		y
///@arg	{string}	str
///@arg	{real}		xscale
///@arg	{real}		yscale
///@arg	{real}		angle
///@arg	{real}		shd_space
///@arg	{real}		shd_colour
function draw_text_transformed_shadow(xx,yy,str,xscale,yscale,angle,shd_space,shd_col){
	var svd=draw_get_color()
	
	draw_set_color(shd_col)
	draw_text_transformed(xx+shd_space,yy+shd_space,str,xscale,yscale,angle)
	draw_set_color(svd)
	
	draw_text_transformed(xx,yy,str,xscale,yscale,angle)
}

function draw_pixel(x, y, w, h, col = draw_get_color(), alp = draw_get_alpha(), rot = 0) {
	draw_sprite_ext(spr_pixel, 0, x, y, w, h, rot, col, alp);
}
function draw_pixel_center(x, y, w, h, col = draw_get_color(), alp = draw_get_alpha(), rot = 0){
	draw_sprite_ext(spr_pixelfour, 0, x, y, w/4, h/4, rot, col, alp);
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

///@desc 0 for Audio, 1 for BGM. If something else is inputted, returns 0
function volume_get(type){
	if type == 0
		return o_world.volume_sfx * o_world.volume_master
    if type == 1
		return o_world.volume_bgm * o_world.volume_master
    
	return 0
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
        do_animate(a, b, time, "linear", o_fader, "image_alpha")
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
        do_animate(a, b, time, "linear", o_flash, "image_alpha")
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

/// @desc a function that creates a text typer and returns its instance
/// @arg {string|array<string>} text the text that the instance will print out. can be both an array that will be split by {p}{c} and a simple string
/// @arg {real} x the x position of the to be created text typer instance
/// @arg {real} y the y position of the to be created text typer instance
/// @arg {real} depth the depth of the to be created text typer instance
/// @arg {string} prefix the string that will be added to the beginning of text
/// @arg {string} postfix the string that will be added to the tail of text (before {stop})
/// @arg {struct} var_struct the variable struct of the text typer. is a post variable struct
/// @arg {bool} end_with_stop true by default. whether the function should add "{stop}" after the string. highly recommended, since the abscence of stop can lead to softlocks
function text_typer_create(text, _xx, _yy, _depth = 0, prefix = "", postfix = "", var_struct = {}, end_with_stop = true) {
    var inst = instance_create(
        o_text_typer, 
        _xx, _yy, _depth, 
        var_struct
    )
    inst.text = prefix + dialogue_array_to_string(text) + postfix + (end_with_stop ? "{stop}" : "")
    
    return inst
}