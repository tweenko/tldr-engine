name = "complete chapter"

execute_code = function() {
	cutscene_create(); 
	
	cutscene_dialogue("* This will overwrite your save file on slot 3. Do you want to continue?")
	cutscene_choicer(["Yes", "No"]);
	
	cutscene_func(function() {
		if global.temp_choice == 0 {
			var _text = save_get("COMPLETED") ? "FALSE" : "TRUE"
			var _dial = string("* Save struct flag {col(y)}'COMPLETED'\{col(w)} set to {col(r)}{0}{col(w)}. Save file created on slot 3.", _text);
			var _p = !save_get("COMPLETED") ? 1 : 0.7
			cutscene_create();
			cutscene_func(save_set, ["COMPLETED", !save_get("COMPLETED")]);
			cutscene_func(save_export_to_file, 2);
			cutscene_audio_play(snd_save, false, 1, _p);
		
			cutscene_dialogue(_dial);
			cutscene_play();
		}
	});	
	
	cutscene_play();
}