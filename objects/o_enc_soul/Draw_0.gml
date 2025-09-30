if instance_exists(inst_aura) {
    with inst_aura {
        var i = 0.25;
        
        while (i <= 0.5) {
            draw_set_alpha((0.5 - (i * 0.5)) * 0.5);
            draw_circle_color(other.x - 1, other.y - 1, (radius * i) + (sin(timer) * 0.25), c_white, c_white, false)
            i += max(0.025, 0.1 - (((power(i * 10, 1.035) / 10) - 0.25) / 3));
        }
        
        draw_set_alpha(1);
    }
}

if color == 0 {
	if outline > 0 { 
		draw_sprite_ext(sprite_index, image_index, 
			x, y,
			image_xscale, image_yscale,
			image_angle, image_blend, (1-outline) * image_alpha
		)
		draw_sprite_ext(spr_eff_soul_outline, image_index, 
			x, y,
			image_xscale, image_yscale,
			image_angle, image_blend, outline * image_alpha
		)
	}
	else
		draw_self()
}