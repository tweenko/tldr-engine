function item_key() : item() constructor {
	type = ITEM_TYPE.KEY
    
    shop_max_sell = 1
}

function item_key_cell_phone() : item_key() constructor {
	name = ["Cell Phone"]
	desc = ["It can be used to make calls.", "--"]
	
	use = function() {
		instance_destroy(o_ui_menu)
		
		cutscene_create()
		cutscene_player_canmove(false)
		
		cutscene_dialogue("{can_skip(false)}" + loc("item_key_cell_phone_cutscene")[0], "", false)
		cutscene_sleep(40)
		
		cutscene_func(music_pause, [0])
		cutscene_audio_play(snd_smile)
		cutscene_sleep(1)
		cutscene_wait_until(function() {
			return !audio_is_playing(snd_smile)
		})
		
		cutscene_func(function() {
			instance_destroy(o_ui_dialogue)
		})
		cutscene_func(music_resume, [0])
		cutscene_dialogue(loc("item_key_cell_phone_cutscene")[1])
		
		cutscene_player_canmove(true)
		cutscene_play()
	}
    
    item_localize("item_key_cell_phone")
}
item_register(item_key_cell_phone);

function item_key_claimbclaws() : item_key() constructor {
	name = ["ClaimbClaws"];
	desc = ["Claws so small they conveniently can't\nbe seen. Use them to climb up obvious walls.", "--"];
	
    can_use = false;
    
    item_localize("item_key_claimb_claws");
}
item_register(item_key_claimbclaws);