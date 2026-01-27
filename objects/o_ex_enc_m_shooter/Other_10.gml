// change the sprites of the party
for (var i = 0; i < array_length(global.party_names); ++i) {
	if struct_exists(shoot_sprites, global.party_names[i]){
		var o = party_get_inst(global.party_names[i])
		o.sprite_index = struct_get(shoot_sprites, global.party_names[i])
		
		var aft = afterimage(.03, o)
		aft.depth = o.depth-10
		aft.white = true
		aft.image_alpha = 1
		
		aft = afterimage(.02, o)
		aft.speed = .8
		
		aft = afterimage(.03, o)
		aft.speed = 1.6
		
		aft = afterimage(.04, o)
		aft.speed = 2.4
	}
}

// setup the shadowguys to have socks and move
for (var i = 0; i < array_length(o_enc.encounter_data.enemies); ++i) {
	var _enemy = o_enc.encounter_data.enemies[i]
	if _enemy.name == "Shadowguy" && enc_enemy_isfighting(i) && instance_exists(_enemy.actor_id){
		array_push(saved_pos, [_enemy.actor_id.x, _enemy.actor_id.y])
		animate(1, 0, 10, "linear", _enemy.actor_id, "flash")
		_enemy.actor_id.image_index = 0
		
		with(_enemy.actor_id){ // create socks
			moveseed = [random_range(10, 14), random_range(-90, 90)]
			my_socks = instance_create(o_ex_enc_m_sguy_socks, 
				x, y, DEPTH_ENCOUNTER.BULLETS_OUTSIDE, 
				{ caller: self.id }
			)
		}
	}
	else array_push(saved_pos, -1)
}