//trigger_code = function(){
//	(new ex_enc_set_shadowguys()).start()
//}

visible = true

trigger_code = function() {
	cutscene_create()
	cutscene_dialogue("* ok so i did this choice thing...{p}{c}* do you like it?{p}{c}{choice(Yes, Absolutely, For real, No)}{e}")
	
	cutscene_func(function() {
		if global.temp_choice == 3{
			dialogue_start("* d-damn. i'm sorry i guess.")
			return -1
		}
		dialogue_start("* ok bro thanks for the review")
	})
	cutscene_wait_until(function() { 
		return !instance_exists(o_ui_dialogue) 
	})
	
	cutscene_play()
}