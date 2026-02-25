count = 0
trigger_code = function() { 
	cutscene_create()
	if count == 0 {
		cutscene_dialogue([
			"* Nothing good awaits you here.",
		])
    }
    else {
		cutscene_dialogue([
			"* Other way",
		])
	}
	cutscene_func(function() {
		actor_move(get_leader(), new actor_movement(20, 0, 30,,, DIR.LEFT, false))
	})
    
	cutscene_sleep(20)
	cutscene_set_variable(id, "triggered", false)
	cutscene_party_interpolate()
	cutscene_play()
	
	count++
}