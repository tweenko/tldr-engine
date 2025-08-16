if fadeout{
	if uialpha > 0 uialpha -= .1
	if uialpha <= 0 
		instance_destroy()
}
else {
	if start_timer 
        timer --
	siner ++
	
	if siner == 1 exit
	
	if sguy_amp < 10 && start_timer sguy_amp += .5
	
	if start_timer {
		// move around shadowguys and snap socks
		for (var i = 0; i < array_length(o_enc.encounter_data.enemies); ++i) {
			var enemy = o_enc.encounter_data.enemies[i]
			if enemy.name == "Shadowguy" && enc_enemy_isfighting(i) && instance_exists(enemy.actor_id){
				var e_o = enemy.actor_id
				e_o.x = saved_pos[i][0] + sin((siner + e_o.moveseed[1]) / e_o.moveseed[0]) * sguy_amp
				e_o.y = saved_pos[i][1] + cos((siner + e_o.moveseed[1]) / e_o.moveseed[0]) * sguy_amp/2 + sin((siner + 30) / 14) * (16 * sguy_amp/10)
			
				with(e_o) {
					if my_socks.collide {
						my_socks.x = x
						my_socks.y = y
					}
				}
			}
		}
	}
	
	var xrange = 50
	var yrange = 60
	
	if input_check(all) && !start_timer{
		start_timer = true
		event_user(0)
	}
	
	if input_check("up") && y-ystart > -yrange
		y -= 2
	else if input_check("down") && y-ystart < yrange
		y += 2
	if input_check("left") && x-xstart > -xrange
		x -= 2
	else if input_check("right") && x-xstart < xrange
		x += 2
		
	if input_check("menu") && buffer == 0 && ammo > 0{
		buffer = 5
		for (var i = 0; i < array_length(global.party_names); ++i) {
			var o = party_get_inst(global.party_names[i])
			
			ammo -= 1
			
			instance_create(o_ex_enc_m_sguy_soul, o.x + 16, o.y-o.myheight/2, DEPTH_ENCOUNTER.BULLETS_OUTSIDE-10, {
				direction: point_direction(o.x + 16, o.y-o.myheight/2, 
					x + random_range(-5, 5), 
					y + random_range(-5, 5)
				),
				speed: 30
			})
		}
	}
	
	if ammo <= 0 {
		ammo = 0
		fadeout = true
		uialpha = 2
	}
	
	if timer <= 0{
		fadeout = true
		uialpha = 2
	}
}

if buffer > 0 buffer--

//if instance_exists(eff_bg) 
//	eff_bg.fade = uialpha/2