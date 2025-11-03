active = false
console_caller = function() {
	return keyboard_check_pressed(vk_tab)
}

registred_commands = {
	h: {
		name: "help",
		desc: "Helps you, apparently.",
		
		execute: function() {
			var _msg = "\nBelow are the keys you can use with [Tab] and what they do.\n"
			var __nms = struct_get_names(o_console.registred_commands)
			
			for (var i = 0; i < array_length(__nms); ++i) {
				var __cmd = struct_get(o_console.registred_commands, __nms[i])
				
				_msg += $"[{string_upper(__nms[i])}] {__cmd.name} : {__cmd.desc}" + "\n"
			}
			
			show_debug_message(_msg)
		}
	},
	r: {
		name: "room_select",
		desc: "Lets you select a room to be transported to instantly.",
		execute: function(){
			instance_create(o_dev_roomselect)
		}
	},
	p: {
		name: "party_select",
		desc: "Lets you select the party members you desire to be part of your team.",
		execute: function(){
			instance_create(o_dev_partyselect)
		}
	},
	e: {
		name: "encounter_select",
		desc: "Lets you initiate an encounter from the console instantly.",
		execute: function(){
			instance_create(o_dev_encselect)
		}
	},
    w: {
        name: "encounter_end",
        desc: "Lets you end an encounter instantly.",
        execute: function() {
            if instance_exists(o_enc) {
                if o_enc.battle_state == "turn" {
                    for (var i = 0; i < array_length(o_enc.turn_objects); i ++) {
                        if enc_enemy_isfighting(i)
                            instance_destroy(o_enc.turn_objects[i])
                    }
                }
                else if o_enc.battle_state == "dialogue" {
                    o_enc.battle_state = "turn"
                    with o_enc {
                        for (var i = 0; i < array_length(dialogueinstances); ++i) {
                            if enc_enemy_isfighting(i)
                    	        instance_destroy(dialogueinstances[i])
                    	}
                    }
                    
                    call_later(1, time_source_units_frames, function() {
                        for (var i = 0; i < array_length(o_enc.turn_objects); i ++) {
                            if enc_enemy_isfighting(i)
                                instance_destroy(o_enc.turn_objects[i])
                        }
                    })
                }
                else {
                    instance_destroy(o_enc.menutext)
                    o_enc.battle_state = "win"
                    
                    // destroy the enemy actors
                    for (var i = 0; i < array_length(o_enc.encounter_data.enemies); i ++) {
                        if enc_enemy_isfighting(i)
                            instance_destroy(o_enc.encounter_data.enemies[i].actor_id)
                    }
                }
            }
            else 
                show_debug_message("CONSOLE: o_enc not found, no encounter ended")
        }
    },
    l: {
        name: "language_switch",
        desc: "switches the language of the session",
        execute: function() {
            loc_switch_lang()
        }
    },
    d: {
        name: "save_wipe",
        desc: "Deletes all the save files (including settings!) permanently.",
        execute: function() {
            instance_create(o_dev_savewipe_prompt)
        }
    }
}

depth = DEPTH_UI.CONSOLE

keyhold = 0
curcommand = function() {}