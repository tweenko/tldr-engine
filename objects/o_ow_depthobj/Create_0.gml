event_inherited()

shake = 0
can_reflect = false
reflection_code = function(){
	var ret = image_yscale
	image_yscale = -image_yscale
	event_perform(ev_draw, ev_draw_normal)
	image_yscale = ret
}


s_lightalpha = 0
lighting_darken = 0
am_emmiting_light = false