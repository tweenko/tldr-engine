// destroy socks if possible and move back to where they were
for (var i = 0; i < array_length(o_enc.encounter_data.enemies); ++i) {
	var _enemy = o_enc.encounter_data.enemies[i]
	if _enemy.name == "Shadowguy" && enc_enemy_isfighting(i) && instance_exists(_enemy.actor_id){
		var oo = _enemy.actor_id.my_socks
		var percent = oo.hits/oo.maxhits * 100
		if percent < 100 percent = 20
		
		enc_sparepercent_enemy(i, percent)
		
		if _enemy.actor_id.my_socks.collide
			instance_destroy(_enemy.actor_id.my_socks)
			
		_enemy.actor_id.my_socks = noone
		
		do_animate(.5, 0, 9, "linear", _enemy.actor_id, "darken")
				
		do_animate(_enemy.actor_id.x, saved_pos[i][0], 9, "linear", _enemy.actor_id, "x")
		do_animate(_enemy.actor_id.y, saved_pos[i][1], 9, "linear", _enemy.actor_id, "y")
	}
	
	if enc_enemy_isfighting(i) 
		do_animate(.5, 0, 9, "linear", o_enc.encounter_data.enemies[i].actor_id, "darken")
}

instance_destroy(o_ex_enc_m_sguy_soul)