function item_key_base() : item_base() constructor {
	type = ITEM_TYPE.KEY
}

function item_key_cell_phone() : item_key_base() constructor {
	name = ["Cell Phone"]
	desc = ["It can be used to make calls.", "--"]
	
	use = function() {
		instance_destroy(o_ui_menu)
		
		cutscene_create()
		cutscene_player_canmove(false)
		
		cutscene_dialogue("{can_skip(false)}* (You tried to call on the Cell Phone.){stop}", "", false)
		cutscene_sleep(40)
		
		cutscene_func(music_stop_all)
		cutscene_audio_play(snd_smile)
		cutscene_sleep(1)
		cutscene_wait_until(function() {
			return !audio_is_playing(snd_smile)
		})
		
		cutscene_func(function() {
			instance_destroy(o_ui_dialogue)
		})
		cutscene_dialogue("* It's nothing but garbage noise.")
		
		cutscene_player_canmove(true)
		cutscene_play()
	}
}