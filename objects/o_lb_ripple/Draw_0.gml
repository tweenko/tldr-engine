if timer < 1
	exit;

gpu_set_blendmode(blending);
draw_set_colour(colour);

for (var i = 0; i < thickness; i ++) {
	draw_set_alpha(alpha - i / thickness);
	var _cirsize = size - i * spaced_out;
	
	if _cirsize < 0
		break;
	if _cirsize > 0 && draw_get_alpha() > 0
		CleanNgon(x, y, _cirsize, round(polycount)).Rotate(image_angle).Blend(c_white, 0).Border(round(width), draw_get_colour(), draw_get_alpha()).Rounding(0).Draw();
}

draw_set_alpha(1);
draw_set_colour(c_white);
gpu_set_blendmode(bm_normal);