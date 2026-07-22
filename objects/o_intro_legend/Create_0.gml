event_inherited();
active = false;

/// @ignore
__spawn_text = function(idx, tx, ty, duration=undefined) {
	var typer = text_typer_create(loc("legend_lb")[idx], tx, ty,DEPTH_UI.DIALOGUE_UI, "{can_skip(false)}{shadow(false)}{speed(2)}{voice(nil)}{auto_breaks(false)}", "{stop}", {
			gui: true,
			caller: o_intro_legend,
			destroy_caller: false
		}
	)
		
	if !is_undefined(duration) {
		var ts = time_source_create(o_intro_legend.tsParent, duration, time_source_units_frames, instance_destroy, [typer]);
		time_source_start(ts);
	}
}
	
/// @ignore
__rem = function(i, j) {
	var n = 0;
	if i > 0 {n = i mod j}
	else if i < 0{n = j + i mod j};
	while (n >= j){n -= j}
	return n;
}
	
/// @ignore
__draw_sprite_looped_xy = function(offsetx, offsety, amp, sprite, image, xx, yy, xscale = 1, yscale = 1, angle = 0, color = c_white, alpha = 1, move_x = true, move_y = true, xamt = 2, yamt = 2) {
	var __sw = sprite_get_width(sprite)  * xscale
	var __sh = sprite_get_height(sprite) * yscale
	    
	// pixel–space offsets (smooth, always positive)
	var __ox = (move_x ? __rem(offsetx * amp, __sw) : 0)
	var __oy = (move_y ? __rem(offsety * amp, __sh) : 0)
	
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