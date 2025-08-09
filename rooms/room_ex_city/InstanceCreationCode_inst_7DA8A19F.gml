count=0
trigger_code=function(){
	cutscene_create()
	if count==0{
		cutscene_dialogue([
			"* (You were going to leave, but...)",
			"* (There road was cut abruptly right before you.)"
		])
	}else{
		cutscene_dialogue([
			"* (There is no road.)",
		])
	}
	cutscene_func(function(){
		actor_move(get_leader(),{
			xx: -20,
			yy: 0,
			absolute: false,
			spd: 1,
		})
	})
	cutscene_sleep(20)
	cutscene_set_variable(id, "triggered", false)
	cutscene_party_interpolate()
	cutscene_play()
	
	count++
}