x = round(x)
y = round(y)

image_blend = c_red

draw_sprite_ext(sprite_index, image_index,
	x, y, .5, .5, 
	image_angle, image_blend, image_alpha
)

if image_xscale > .5 || image_yscale > .5{
	draw_sprite_ext(sprite_index, image_index,
		x, y, image_xscale, image_yscale,
		image_angle, image_blend, image_alpha
	)
}

image_blend = c_white

draw_sprite_ext(sprite_index, image_index, 
	x, y, .5, .5, 
	image_angle, image_blend, image_alpha
)
if image_xscale > .5 || image_yscale > .5{
	draw_sprite_ext(sprite_index, image_index,
		x, y, image_xscale, image_yscale,
		image_angle, image_blend, image_alpha
	)
}