function item_light() : item() constructor {
	type = ITEM_TYPE.LIGHT;
}

function item_lw_shit() : item_light() constructor {
	name = ["Actual Shit"]
	desc = ["* Nobody knows what it actually does...", "HOW"]
	
    dw_counterpart = item_darker_candy
    
	use = function(item_index, target_index, caller) {
		dialogue_start("* You smell the shit...{br}{resetx}{s(10)}* Ew. Why did you do that.")
	}
	throw_scripts = {
		can: true,
        item_type: type,
		execute_code: method(self, function(index, item_index){
			dialogue_start("* You dropped the shit. Now the room stinks. Thanks.")
			item_delete(item_index, item_type);
		})
	}
    
    sell_price = 2
}
item_register(item_lw_shit);

function item_lw_bandage() : item_light() constructor {
    name = ["Bandage"]
    desc = ["", "--"]
    
    use = method(self, function(item_index, target_index, caller) {
        audio_play(snd_heal)
        save_set("LW_HP", clamp(save_get("LW_HP") + 10, 0, save_get("LW_MAXHP")))
		dialogue_start(loc("item_c_lw_bandage_apply"))
        
        item_delete(item_index, type);
	})
    
    item_localize("item_c_lw_bandage")
}
item_register(item_lw_bandage);