if !is_in_battle && freeze == 0 { // enemy aura, toby code
	var spr = sprite_index
	if hurt > 0  
		spr = s_hurt
	
	var xx = x + xoff + sine(1, shake)
	var yy = y + yoff
	
	if onscreen(id, 30) && hurt == 0 {
	    var drawscale = 1
		
		gpu_set_blendmode(bm_add)
	    for (var i = 0; i < 5; i++) {
	        var aura = ((i * 9) + ((drawsiner * 3) % 9))
	        var aurax = ((aura * 0.75) + (sin((aura / 4)) * 4))/2 * sign(image_xscale)
	        var auray = (45 * lerp_type(0, 1, (aura / 45), "sine_in"))/2
	        var aurayscale = min((80 / sprite_height), 1)/2
			
			s_drawer(spr, image_index,
				xx - aurax/180 * drawscale*sprite_width, yy - auray/82 * sprite_height*aurayscale, 
				(image_xscale + aurax/36) * drawscale, image_yscale + auray/36 * aurayscale,
				image_angle, c_red, image_alpha * (1 - auray*2 / 45) * 0.5
			)
	    }
	    gpu_set_blendmode(bm_normal)
	}
	
	s_drawer(spr, image_index, 
		xx, yy, 
		image_xscale, image_yscale,
	   image_angle, image_blend, image_alpha
    )
}
else {
	event_inherited()
}

if notice
    draw_sprite(spr_ui_exclamation, 0, x, y - sprite_height - 2)
