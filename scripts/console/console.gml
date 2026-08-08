#macro AssetTag_command "TLDR_command"

function console_command() constructor {
    hotkey = undefined; // can be an array
    name = "";
    desc = "";
    execute = function() {};
    
    hotkeys_to_string = method(self, function() {
        if !is_array(hotkey)
            return hotkey;
        
        var ret = "";
        for (var i = 0; i < array_length(hotkey); i ++) {
            ret += chr(hotkey[i]);
            if i < array_length(hotkey) - 1
                ret += "+"
        }
        return ret;
    })
}
function console_command_register(_command_script) {
    asset_add_tags(_command_script, AssetTag_command);
}

// default commands
function console_command_help() : console_command() constructor {
    hotkey = ord("H");
    name = "Help";
    desc = "Gives info about the Console System.";
    execute = function() {
        var _msg = "\nBelow are the keys you can use with [Tab] and what they do.\n\n"
        
        for (var i = 0; i < array_length(o_console.registred_commands); ++i) {
            var __cmd = o_console.registred_commands[i];
            
            _msg += $"[{__cmd.hotkeys_to_string()}] {__cmd.name} : {__cmd.desc}" + "\n"
        }
        
        var inst = instance_create(o_dev_console_message);
        inst.drawer = method({message: _msg}, function() {
            draw_text_transformed(32, 32, message, 1, 1, 0);
        });
    };
}
console_command_register(console_command_help);

function console_command_room_select() : console_command() constructor {
    hotkey = ord("R");
    name = "Open Room Select";
    desc = "Lets you select a room to be transported to instantly.";
    execute = function() {
        instance_create(o_dev_roomselect)
    };
}
console_command_register(console_command_room_select);

function console_command_party_select() : console_command() constructor {
    hotkey = ord("P");
    name = "Open Party Select";
    desc = "Lets you select the party members you desire to be part of your team.";
    execute = function() {
        instance_create(o_dev_partyselect)
    };
}
console_command_register(console_command_party_select);

function console_command_enc_select() : console_command() constructor {
    hotkey = ord("E");
    name = "Open Encounter Select";
    desc = "Lets you initiate an encounter from the console instantly.";
    execute = function() {
        instance_create(o_dev_encselect)
    };
}
console_command_register(console_command_enc_select);

function console_command_item_select() : console_command() constructor {
    hotkey = ord("I");
    name = "Open Item Select";
    desc = "Lets you manage inventory items.";
    execute = function() {
        instance_create(o_dev_itemselect);
    };
}
console_command_register(console_command_item_select);

function console_command_enc_end() : console_command() constructor {
    hotkey = ord("W");
    name = "End an Encounter";
    desc = "Lets you end an encounter instantly.";
    execute = function() {
        if instance_exists(o_enc) {
            if o_enc.battle_state == BATTLE_STATE.TURN {
                for (var i = 0; i < array_length(o_enc.turn_objects); i ++) {
                    if enc_enemy_is_fighting(i)
                        instance_destroy(o_enc.turn_objects[i])
                }
                o_enc.turn_objects = [];
                
                o_console.log_text("Enemies' turn Skipped");
            }
            else if o_enc.battle_state == BATTLE_STATE.DIALOGUE {
                o_enc.battle_state = BATTLE_STATE.TURN
                with o_enc {
                    for (var i = 0; i < array_length(inst_dialogues); ++i) {
                        if !instance_exists(inst_dialogues[i])
                            continue;
                        if !instance_exists(inst_dialogues[i].inst)
                            continue;
                        
                        instance_destroy(inst_dialogues[i].inst);
                        instance_destroy(inst_dialogues[i]);
                    }
                    inst_dialogues = [];
                }
                
                o_console.log_text("Dialogue Skip");
            }
            else {
                o_enc.battle_state = BATTLE_STATE.WIN
                
                // destroy the enemy actors
                for (var i = 0; i < array_length(o_enc.encounter_data.enemies); i ++) {
                    if enc_enemy_is_fighting(i)
                        instance_destroy(o_enc.encounter_data.enemies[i].actor_id)
                }
                
                o_console.log_text("Encounter Ended");
            }
            instance_destroy(o_enc_target);
        }
        else {
            o_console.log_text("`o_enc` not found, encounter not ended", c_red);
        }
    };
}
console_command_register(console_command_enc_end);

function console_command_switch_lang() : console_command() constructor {
    hotkey = ord("L");
    name = "Switch Language";
    desc = "Switches the language of the session. will set you back to your last save.";
    execute = function() {
        loc_switch_lang()
        o_console.log_text($"Language switched to {global.loc_lang}", c_orange);
    };
}
console_command_register(console_command_switch_lang);

function console_command_save_wipe() : console_command() constructor {
    hotkey = ord("D");
    name = "Wipe Save Files";
    desc = "Deletes all the save files (including settings!) permanently.";
    execute = function() {
        instance_create(o_dev_savewipe_prompt)
    };
}
console_command_register(console_command_save_wipe);

function console_command_max_tp() : console_command() constructor {
    hotkey = ord("T");
    name = "Max out TP";
    desc = "Sets TP to 100% during an encounter.";
    execute = function() {
        if instance_exists(o_enc) {
            o_enc.tp = 100;
            audio_play(snd_cardrive,, 1, 1.2);
            audio_play(snd_wing,, 1, 1.2);
        }
        else 
            o_console.log_text("`o_enc` not found, TP not set", c_red);
    };
}
console_command_register(console_command_max_tp);

function console_command_mute_bgm() : console_command() constructor {
    hotkey = ord("M");
    name = "Toggle Mute BGM";
    desc = "Mutes/Unmutes BGM, persists through reloads.";
    execute = function() {
        o_world.volume_bgm = (o_world.volume_bgm > 0 ? 0 : 1);
        audio_emitter_gain(o_world.emitter_bgm, o_world.volume_bgm); 
        
        o_console.log_text($"BGM's volume set to {o_world.volume_bgm}", c_orange);
    };
}
console_command_register(console_command_mute_bgm);

function console_command_intro() : console_command() constructor {
	hotkey = ord("N");
	name = "Open Intro Sequence";
	desc = "Lets you check any intro sequence there is available.";
	execute = function() {
		instance_create(o_dev_introselect);
	}
}
console_command_register(console_command_intro);


function console_log(_text, _drawer = method(self, function(_offx = 0, _offy = 0) {
    draw_set_alpha(alpha * .75);
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_colour(c_black);
    draw_set_font(font_main);
    
    draw_rectangle(x + _offx + offset_x - width*xscale, y + _offy + offset_y - height*yscale - 8, x + _offx + offset_x, y + _offy + offset_y, false);
    
    draw_set_colour(color);
    draw_set_alpha(alpha);
    draw_text_ext_transformed(x + _offx + offset_x, y + _offy + offset_y, text, 20, width, xscale, yscale, angle);
    
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
})) constructor {
    text = _text;
    draw = _drawer;
    
    x = 640 - 20;
    y = 480 - 10;
    
    draw_set_font(font_main);
    
    max_width = 300;
    width = string_width_ext(text, 20, max_width);
    height = string_height_ext(text, 20, max_width);
    color = c_white;
    
    xscale = 1;
    yscale = 1;
    angle = 0;
    alpha = 0;
    
    offset_x = 100;
    offset_y = 0;
    animate(100, 0, 15, anime_curve.sine_out, self, "offset_x");
    animate(alpha, 1, 15, anime_curve.linear, self, "alpha");
    
    timer = 0;
    timer_expire = 120;
    time_source = call_later(1, time_source_units_frames, method(self, function() {
        timer ++;
        
        if timer == timer_expire {
            animate(offset_x, -30, 15, anime_curve.sine_in, self, "offset_x");
            animate(alpha, 0, 15, anime_curve.linear, self, "alpha");
            
            call_cancel(time_source);
            if time_source_exists(time_source)
                time_source_destroy(time_source);
        }
    }), true);
}
