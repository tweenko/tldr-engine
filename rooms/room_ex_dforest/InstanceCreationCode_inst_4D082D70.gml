count = 0
trigger_code = function() {
	cutscene_create()
	if count == 0 {
		cutscene_dialogue([
			"* (You were going to leave, but...)",
			"* (There road was cut abruptly right before you.)"
		])
	}
    else{
		cutscene_dialogue([
			"* (There is no road.)",
		])
	}
    
	cutscene_func(function(){
		actor_move(get_leader(), new actor_movement(0, -20, 30,,, DIR.DOWN, false))
	})
    
	cutscene_sleep(20)
	cutscene_set_variable(id, "triggered", false)
	cutscene_party_interpolate()
	cutscene_play()
	
	count ++
}