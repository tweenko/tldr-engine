name = "kris jump alone"

execute_code = function() {
    cutscene_create()
	cutscene_player_canmove(false)
	cutscene_party_follow(false)
    
	cutscene_actor_move(o_actor_kris, [
		new actor_movement_jump(100, 140),
		new actor_movement(100, 200, 20,,,DIR.LEFT),
		new actor_movement_jump(o_actor_kris.x, o_actor_kris.y),
	])
    
	cutscene_wait_until(function(){
        return !instance_exists(o_actor_mover)
    })
    
	cutscene_player_canmove(true)
	cutscene_party_follow(true)
	cutscene_party_interpolate()
    
	cutscene_play()
}