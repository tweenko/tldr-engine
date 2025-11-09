/// @desc turns on the dodge mode
function dodge_on() {
    if !instance_exists(o_dodge_controller)
        return false
    o_dodge_controller.dodge_mode = true
}

/// @desc turns off the dodge mode
function dodge_off() {
    if !instance_exists(o_dodge_controller)
        return false
    
    o_dodge_controller.dodge_mode = false
}

/// @desc draw_self except it darkens depending on dodge_alpha (overworld battle darken)
/// @arg {function|undefined} drawer the function that draws your object
function dodge_darken_self(drawer = undefined) {
    if !instance_exists(o_dodge_controller)
        return false
    
    if !is_undefined(drawer) && is_callable(drawer)
        drawer(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_black, dodge_getalpha() * o_dodge_controller.dodge_darken)
    else
	   draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_black, dodge_getalpha() * o_dodge_controller.dodge_darken)
}
///@desc returns the alpha of the overworld battle mode
function dodge_getalpha(){
	if !instance_exists(o_dodge_controller)
        return 0
	return o_dodge_controller.dodge_alpha
}
///@desc game over!
function dodge_gameover(){
	instance_create(o_gameover, 
		o_dodge_soul.x - guipos_x(), o_dodge_soul.y - guipos_y(), DEPTH_ENCOUNTER.UI,
		{
			image_blend: o_dodge_soul.image_blend,
			freezeframe: sprite_create_from_surface(application_surface, 0, 0, 640, 480, 0, 0, 0, 0),
			freezeframe_gui: sprite_create_from_surface((instance_exists(o_ui_menu) ? o_ui_menu.surf : -1), 0, 0, 640, 480, 0, 0, 0, 0),
		}
	)
	
	room_goto(room_gameover)
	
	audio_stop_all()
	audio_play(snd_hurt)
}