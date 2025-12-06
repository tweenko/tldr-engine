event_inherited()

if type == 0 { // sax attack
	if timer == 6 {
		var o = enemy_struct.actor_id
		o.sprite_index = spr_ex_e_sguy_sax
		o.custom_depth = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y-guipos_y())
		o.depth = o.custom_depth
	
		notepath = instance_create(o_ex_sguy_notepath)
	
		notepath.xx = o_enc_soul.x
		notepath.yy = o_enc_soul.y
		notepath.shadx = o.x-o.sprite_xoffset + 10
		notepath.shady = o.y-o.sprite_yoffset + 38
		
        notepath.ency = o_enc_box.y
	
		with notepath 
            event_user(0)
	
		notepath.depth = o.depth + 10
	}
    
	if timer % 70 == 0 && timer > 6 {
		var o = enemy_struct.actor_id
		notepath = instance_create(o_ex_sguy_notepath)
	
		notepath.xx = o_enc_soul.x
		notepath.yy = o_enc_soul.y
		notepath.shadx = o.x-o.sprite_xoffset + 10
		notepath.shady = o.y-o.sprite_yoffset + 38
		notepath.ency = o_enc_box.y
	
		with notepath 
            event_user(0)
	
		notepath.depth = o.depth+10
	}
	if timer == timer_end - 15 {
		var o = enemy_struct.actor_id
		o.sprite_index = spr_ex_e_sguy_idle
		o.custom_depth = undefined
	
		instance_destroy()
	}
}
else { // gun attack
	if timer == 6 {
		var o = enemy_struct.actor_id
		o.gun = true
		o.gun_angle = 0
		animate(o.x, o.x + 20, 15, "cubic_out", o, "x")
        
		o.custom_depth = DEPTH_ENCOUNTER.BULLETS_OUTSIDE - (o.y-guipos_y())
	}
	if timer > 6 + 15 && timer % 5 == 0 && count < 12 && timer < timer_end - 15 {
		var o = enemy_struct.actor_id
        
		animate(1, 3, 2, 0, o, "gun_img")
		o.gun_angle = point_direction(o.x - 6, o.y - 16, o_enc_soul.x, o_enc_soul.y) + random_range(-25, 25) - 180
		var a = o.gun_angle - 180
		
		var inst = instance_create(o_ex_bullet_sguy_bullet, o.x-18 + lengthdir_x(26, a), o.y-24 + lengthdir_y(26, a)-8, DEPTH_ENCOUNTER.BULLETS_OUTSIDE)
		inst.direction = o.gun_angle + 180
		inst.image_angle = inst.direction-180
		inst.speed = 4
		
		count ++
	}
	
	if count == 12 && !reloading && timer < timer_end - 15 {
		var o = enemy_struct.actor_id
		o.sprite_index = spr_ex_e_sguy_reload
		o.gun = false
		reloading = true
	}
	if reloading && timer < 200 - 15 {
		ttimer ++
	}
	if count == 12 && reloading && ttimer == 25 && timer < timer_end - 15 {
		var o = enemy_struct.actor_id
		o.sprite_index = spr_ex_e_sguy_reload
		o.image_speed = 1
		
		o.gun = true
		o.gun_angle = 0
		
		reloading = false
		ttimer = 0
		count = 0
	}
	if timer >= timer_end - 17 && !ending_turn {
		var o = enemy_struct.actor_id
		o.gun = false
		o.sprite_index = spr_ex_e_sguy_reload
		animate(o.x, o.x-20, 15, "cubic_out", o, "x")
        ending_turn = true
	}
	if timer == timer_end {
		var o = enemy_struct.actor_id
		o.sprite_index = spr_ex_e_sguy_idle
		o.custom_depth = undefined
		instance_destroy()
	}
}