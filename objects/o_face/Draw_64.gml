var spr = f_sprite
var img = 0

if is_string(facename) {
    if spr == -1
    	spr = struct_get(face_expressions, facename)
    else
    	img = struct_get(face_expressions, facename)
}
else {
	img = facename
}

draw_sprite_ext(spr, img, 
    x + 26 * image_xscale, y + (instance_exists(o_enc) ? 26 : 30) * image_yscale, 
    image_xscale, image_xscale, 
    0, c_white, image_alpha
)