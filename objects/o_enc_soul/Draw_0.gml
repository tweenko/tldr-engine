if color == 0{
	if outline>0{
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