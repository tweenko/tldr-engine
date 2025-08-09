if get_leader().dodge_lerper == 0 
	exit
draw_sprite_ext(spr_pixel, 0, guipos_x(), guipos_y(), 320, 240, 0, c_black, .5 * get_leader().dodge_lerper) // darken bg

if layer_exists("t_battle") {
	layer_set_visible("t_battle", true);
	var lay_id = layer_get_id("t_battle");
	
	layer_script_begin(lay_id, function() {
		shader_set(shd_transparent)
		shader_set_uniform_f(shader_get_uniform(shd_transparent, "alpha"), get_leader().dodge_lerper)
	})
	
	layer_script_end(lay_id, function() {
		if shader_current() != -1 {
			shader_reset()
		}
	})
}