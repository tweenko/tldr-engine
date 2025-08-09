if place_meeting(x, y, o_ex_enc_m_sguy_socks) && !dropping{
	var o = instance_nearest(x, y, o_ex_enc_m_sguy_socks)
	
	if o.collide {
		if irandom(1) == 0 
            instance_create(o_ex_eff_sguy_soulhit, x, y, depth-10)
		o.hits += 1
		o.shake = 2
	
		speed = 4
		direction = 90 + random_range(-10, 10)
		gravity = .3
	
		dropping = true
	}
}

if dropping {
	afterimage(.1)
	if y > guipos_y()+240+10
		instance_destroy()
}
else{
	var a = afterimage(.2)
	a.image_alpha = .5
	a.x -= lengthdir_x(speed/3, direction)
	a.y -= lengthdir_y(speed/3, direction)
	
	a = afterimage(.2)
	a.image_alpha = .5
	a.x -= lengthdir_x(speed/3*2, direction)
	a.y -= lengthdir_y(speed/3*2, direction)
}

if trail < 10 trail += 2

if !onscreen(id) instance_destroy()