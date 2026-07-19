members = []
name = "complete chapter"

execute_code = function() {
	cutscene_create(); 
	cutscene_func(save_set, ["COMPLETED", true]);
	cutscene_audio_play(snd_save);
	
	cutscene_wait_until(function(){
		return save_get("COMPLETED", false) == true
	})
	cutscene_dialogue(["* Save struct flag {col(y)}'COMPLETED'{col(w)} set to {col(r)}true{col(w)}. You can SAVE your game now."]);
	cutscene_play();
}