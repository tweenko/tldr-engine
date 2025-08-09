var __ww = sprite_width/image_xscale
var __hh = sprite_height/image_yscale

if !surface_exists(surf)
	surf = surface_create(__ww, __hh)
if !surface_exists(surf_aura)
	surf_aura = surface_create(__ww, __hh)

var propblue = 0xFFD042
var liteblue = 16777215
image_blend = propblue

if image_alpha < 0 || !onscreen(id, 30)
	exit

surface_set_target(surf)
	draw_clear_alpha(0,0)
	draw_sprite_looped(siner, -.5, spr_depth_loop, 0, 0, 0,,,, propblue, 1)

	gpu_set_blendmode(bm_subtract)
	draw_sprite_ext(sprite_index, image_index, sprite_xoffset, sprite_yoffset, 1, 1, 0, c_black, 1)

	gpu_set_blendmode(bm_normal)
surface_reset_target()

var line_col = merge_color(merge_color(0xEFE98B, 0xFFED17, (0.5 + (sin(siner / 120)) * 0.5)), c_black, .5)

surface_set_target(surf_aura)
	draw_clear_alpha(0, 0)
	
	draw_sprite_ext(spr_pixel, 0, 0, 0, __ww, __hh, 0, 0xFFF8A3, aura_alpha)
	draw_sprite_looped(siner, .5, spr_depth_blur_loop, 0, 0, 0,,,, line_col, aura_alpha)
	
	gpu_set_blendmode(bm_subtract)
	draw_sprite_stretched_ext(spr_gradient, 0, 0, 0, __ww, __hh/2, c_black, 1)
	draw_sprite_stretched_ext(spr_gradient, 1, __ww/2, 0, __ww/2, __hh, c_black, 1)
	draw_sprite_stretched_ext(spr_gradient, 2, 0, __hh/2, __ww, __hh/2, c_black, 1)
	draw_sprite_stretched_ext(spr_gradient, 3, 0, 0, __ww/2, __hh, c_black, 1)
	gpu_set_blendmode(bm_normal)
	
	gpu_set_blendmode(bm_add)
	draw_surface(surf, 0, 0)
	draw_surface(surf, 0, 0)
	draw_surface(surf, 0, 0)
	gpu_set_blendmode(bm_normal)
surface_reset_target()

var yoff = cosine(12, 2)
var _offset = cos(siner / 12) * 4
for (var i = 1; i < 3; i++) {
	draw_surface_ext(surf_aura, x - sprite_xoffset + _offset * i, y + yoff - sprite_yoffset + _offset * i, image_xscale, image_yscale, image_angle, c_white, image_alpha/4)
}
draw_surface_ext(surf_aura, x - sprite_xoffset, y + yoff - sprite_yoffset, image_xscale, image_yscale, image_angle, c_white, image_alpha)