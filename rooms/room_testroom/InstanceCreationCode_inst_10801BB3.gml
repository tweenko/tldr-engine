execute_func = function() {
	cutscene_create()
	cutscene_player_canmove(false)
	cutscene_party_follow(false)
	
	for (var i = 0; i < array_length(global.party_names); ++i) {
	    cutscene_actor_move(party_getobj(global.party_names[i]), [
            new __actor_movement(room_width/2 - (array_length(global.party_names)-1) * 15 + i*30, 140, 30),
		], i, false)
	}
	cutscene_wait_until(function() {
        return !instance_exists(o_actor_mover)
    })
	
	cutscene_player_canmove(true)
	
	cutscene_party_follow(true)
	cutscene_party_interpolate()
	cutscene_play()
}