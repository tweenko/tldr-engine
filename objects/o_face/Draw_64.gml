var spr = f_sprite
var img = 0

if spr == -1
	spr = struct_get(face_expressions, facename)
else
	img = struct_get(face_expressions, facename)

draw_sprite_ext(spr, img, x + 52, y + (instance_exists(o_enc) ? 52 : 60), 2, 2, 0, c_white, 1)