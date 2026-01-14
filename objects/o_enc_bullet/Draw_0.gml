if inside { // draws on the box surface
    if !instance_exists(o_enc_box)
        exit
	surface_set_target(o_enc_box.bullet_surf)
        gpu_set_colourwriteenable(true, true, true, false)
        
        var savex = x; var savey = y;
        x -= guipos_x(); x += o_enc_box.bullet_surf_safe
        y -= guipos_y(); y += o_enc_box.bullet_surf_safe
        image_xscale *= 2; image_yscale *= 2
        x *= 2; y *= 2
        
    	event_user(1)
        x = savex; y = savey
        image_xscale /= 2; image_yscale /= 2
        
        gpu_set_colourwriteenable(true, true, true, true)
	surface_reset_target()
}
else
	event_user(1)