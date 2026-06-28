function item_spell() : item() constructor {
	type = ITEM_TYPE.SPELL;
	is_mercyspell = false; // does it allow to spare enemies?
    mercyspell_condition = undefined; // a callable function that returns whether an enemy struct (argument 0) can be spared using this spell. only for spells that can spare enemies
    
    highlight_button_target = "power"; // "act", "power", etc
    highlight_button = function(encounter_data) { return false }; // highlights button when true
    
    use = function(spell_user, target, caller = -1) {};
}

function item_s_act() : item_spell() constructor {
	name = "ACT";
	desc = "You can do many things.\nDon't confuse it with magic.";
	
	tp_cost = 0;
    
    item_localize("item_s_act");
}
	
function item_s_rudebuster() : item_spell() constructor {
	name = "Rude Buster";
	desc = ["Deals moderate Rude-elemental damage to one foe. Depends on Attack & Magic.", "Rude Damage"];
	use_type = ITEM_USE.ENEMY;
	tp_cost = 50
	
    use = function(spell_user, target, caller = -1) {
        if !enc_enemy_is_fighting(target)
            exit;
        var __e_obj = o_enc.encounter_data.enemies[target].actor_id;
        
        cutscene_enc_wait(true);
		cutscene_dialogue(loc_string("item_spell_cast", party_getname(spell_user), string_upper(loc("spell_rude_buster_name"))),, false);
        cutscene_sleep(20);
        
        cutscene_set_partysprite(spell_user, "rudebuster");
        cutscene_wait_until(function(__name) {
            return party_get_inst(__name).image_index >= 6
        }, [spell_user])
        cutscene_func(instance_destroy, [o_ui_dialogue])
        cutscene_func(function(tgt, m, _slot, name) {
            var inst = instance_create(o_eff_rudebuster, m.x + m.sprite_width/2 - 30, m.s_get_middle_y(), tgt.depth - 50)
            inst.target_x = tgt.x
            inst.target_y = tgt.s_get_middle_y()
            
            inst.enemy_o = tgt
            inst.slot = _slot
            inst.dmg = party_getdata(name, "attack") * 11 + party_getdata(name, "magic") * 5 - o_enc.encounter_data.enemies[_slot].defense * 3
            inst.user = name
            
            inst.image_angle = point_direction(inst.x, inst.y, tgt.x, tgt.s_get_middle_y()) - 20
            inst.speed = 12
            inst.friction = -1.5/2
            inst.direction = inst.image_angle
            
            animate(0, 1, 3, "linear", inst, "image_alpha")
        }, [__e_obj, party_get_inst(spell_user), target, spell_user])
        cutscene_sleep(50)
        cutscene_set_partysprite(spell_user, "idle")
		cutscene_enc_wait(false)
    }
    
    item_localize("item_s_rude_buster");
}
function item_s_susieheal(data = {
        progress: 0,
        uses: 0,
    }) : item_spell() constructor {
    
    use_type = ITEM_USE.INDIVIDUAL
    _data = data
    
    __heal_calc = function(user) {
        return 1
    }
    __update_spell = function(__data) {
        _data = __data
        
        var __prog = _data.progress
        if __prog == 0 {
            tp_cost = 100
            __heal_calc = function(user) {
                return party_getdata(user, "magic") + 1
            }
        }
        else if __prog == 1 {
           _data.uses = clamp(_data.uses, 0, 5)
            
            tp_cost = 90 - _data.uses
            __heal_calc = function(user) {
                return round(party_getdata(user, "magic") * 1.5 + 5) + _data.uses
            }
        }
        else if __prog == 2 {
            _data.uses = clamp(_data.uses, 0, 15)
            
            tp_cost = 85
            tp_cost -= clamp((_data.uses div 3) + 1, 0, 5)
            
            __heal_calc = function(user) {
                return round(party_getdata(user, "magic") * 5 + 15) + _data.uses*2
            }
        }
        else if __prog >= 3 {
            _data.uses = clamp(_data.uses, 0, 15)
            
            tp_cost = 80
            tp_cost -= clamp((_data.uses div 3) + 1, 0, 5)
            
            __heal_calc = function(user) {
                return round(party_getdata(user, "magic") * 7 + 15) + _data.uses*2
            }
        }
        
        name = [loc("item_s_susieheal_name")[__prog]]
        desc = loc("item_s_susieheal_desc")[__prog]
        
        self._data = __data
        use_args = [name[0], __heal_calc, function(){
            _data.uses ++
            __update_spell(_data)
        }]
    }
    
    use = function(spell_user, target, caller, _spell_name, _calc, _use) {
        cutscene_enc_wait(true)
		cutscene_dialogue(loc_string("item_spell_cast", party_getname(spell_user), _spell_name),, false)
        
        cutscene_sleep(10)
        cutscene_func(function(spell_user, target, _spell_name, _calc, _use) {
            party_heal(global.party_names[target], _calc(spell_user))
            _use()
        }, [spell_user, target, _spell_name, _calc, _use])
        
        cutscene_sleep(30)
        cutscene_func(instance_destroy, [o_ui_dialogue])
		cutscene_enc_wait(false)
    }
    
    __update_spell(_data);
}
function item_s_scythemare() : item_spell() constructor {
	name = "Scythemare";
	desc = ["Inflicts all enemies with bad dreams.\nAll TIRED enemies will be SPAREd.", "Spare all\nTIRED foes"];
	use_type = ITEM_USE.EVERYONE;
	tp_cost = 40;
    
    highlight_button = function(encounter_data) {
        for (var i = 0; i < array_length(encounter_data.enemies); i ++) {
            if !enc_enemy_is_fighting(i)
                continue;
            if encounter_data.enemies[i].tired 
                return true;
        }
    };
    
    is_mercyspell = true;
    mercyspell_condition = function(enemy_struct) {
        if enemy_struct.tired 
            return true;
    };
	
    use = function(spell_user, target, caller = -1) {
        cutscene_enc_wait(true);
        
        cutscene_dialogue(loc_string("item_spell_cast", party_getname(spell_user), item_get_name(self)),, false);
        cutscene_sleep(10);
        
        for (var i = 0; i < array_length(o_enc.encounter_data.enemies); i ++) {
            if !enc_enemy_is_fighting(i)
                continue;
            
            var __e_obj = o_enc.encounter_data.enemies[i].actor_id;
            cutscene_instance_create(o_eff_scythemare, __e_obj.x, __e_obj.s_get_middle_y(), __e_obj.depth - 10, {
                target_enemy: i, 
                success: (o_enc.encounter_data.enemies[i].tired)
            });
            cutscene_sleep(7);
        }
        
        cutscene_wait_until(function() {
            return !instance_exists(o_eff_scythemare);
        });
        
        cutscene_func(instance_destroy, [o_ui_dialogue]);
		cutscene_enc_wait(false);
    }
    
    item_localize("item_s_scythemare");
}
	
function item_s_testdmg() : item_spell() constructor {
	name = ["Test Damage"];
	desc = ["Deals little damage to a foe.", "Test Damage"];
	use_type = ITEM_USE.ENEMY;
	tp_cost = 16;
	
	use = function(spell_user, target, caller) {
		cutscene_enc_wait(true)
		cutscene_func(enc_hurt_enemy, [target, 10, user])
		cutscene_dialogue(loc_string("item_spell_cast", party_getname(spell_user), "TEST DAMAGE"),, true)
		cutscene_enc_wait(false)
	}
}

function item_s_pacify() : item_spell() constructor {
	name = ["Pacify"];
	desc = ["SPARE a tired enemy by putting them to sleep.", "Spare TIRED foe"];
	use_type = ITEM_USE.ENEMY;
	tp_cost = 16;
    
    highlight_button = function(encounter_data) {
        for (var i = 0; i < array_length(encounter_data.enemies); i ++) {
            if !enc_enemy_is_fighting(i)
                continue;
            if encounter_data.enemies[i].tired 
                return true;
        }
    };
    
    hint_message = "* {0} cast {1}!{br}{resetx}{sleep(10)}* But the enemy wasn't {col(tired_aqua)}TIRED{reset_col}...";
    is_mercyspell = true;
    mercyspell_condition = function(enemy_struct) {
        if enemy_struct.tired 
            return true;
    };
	color = method(self, function() {
        if highlight_button(o_enc.encounter_data)
            return merge_color(c_aqua, c_blue, 0.3);
        return c_white
    })
	
    use = method(self, function(spell_user, target, caller) {
        if !enc_enemy_is_fighting(target)
            exit
        
        var __e_obj = o_enc.encounter_data.enemies[target].actor_id
        cutscene_enc_wait(true)
        
        if o_enc.encounter_data.enemies[target].tired {
		    cutscene_dialogue(loc_string("item_spell_cast", party_getname(spell_user), item_get_name(self)),, false)
           
            cutscene_sleep(10)
            cutscene_instance_create(o_eff_pacify, __e_obj.x, __e_obj.s_get_middle_y(), __e_obj.depth - 10)
            cutscene_audio_play(snd_spell_pacify)
            cutscene_spare_enemy(target)
            
            cutscene_sleep(30)
        }
        else {
            cutscene_dialogue(string(hint_message, party_getname(spell_user), item_get_name(self)),, false)
            
            cutscene_set_variable(__e_obj, "flash_color", c_blue)
            cutscene_sleep(20)
            cutscene_animate(0, .75, 7, "linear", __e_obj, "flash")
            cutscene_sleep(7)
            cutscene_animate(.75, 0, 7, "linear", __e_obj, "flash")
            cutscene_sleep(10)
            cutscene_set_variable(__e_obj, "flash_color", c_white)
        }
        
        cutscene_func(instance_destroy, [o_ui_dialogue])
		cutscene_enc_wait(false)
    });
    
    item_localize("item_s_pacify");
}
function item_s_healprayer() : item_spell() constructor {
	name = "Heal Prayer";
	desc = ["Heavenly Light restores a little HP to\none party member. Depends on Magic.", "Heal Ally"];
	use_type = ITEM_USE.INDIVIDUAL;
	tp_cost = 32;
	
    use = method(self, function(spell_user, target, caller) {
        cutscene_enc_wait(true)
		cutscene_dialogue(loc_string("item_spell_cast", party_getname(spell_user), item_get_name(self)),, false)
        
        cutscene_sleep(10)
        cutscene_func(method({spell_user, target}, function() {
            party_heal(global.party_names[target], party_getdata(spell_user, "magic") * 5);
        }));
        
        cutscene_sleep(30)
        cutscene_func(instance_destroy, [o_ui_dialogue])
		cutscene_enc_wait(false)
    });
    
    item_localize("item_s_healprayer");
}

function item_s_sleepmist() : item_spell() constructor {
    name = "Sleep Mist";
	desc = ["A cold mist sweeps through, sparing all TIRED enemies.", "Spare TIRED foes"];
	use_type = ITEM_USE.EVERYONE;
	tp_cost = 32;
	
	highlight_button = function(encounter_data) {
        for (var i = 0; i < array_length(encounter_data.enemies); i ++) {
            if !enc_enemy_is_fighting(i)
                continue;
            if encounter_data.enemies[i].tired 
                return true;
        }
    };
    
    is_mercyspell = true;
    mercyspell_condition = function(enemy_struct) {
        if enemy_struct.tired 
            return true;
    };
	color = method(self, function() {
        if highlight_button(o_enc.encounter_data)
            return merge_color(c_aqua, c_blue, 0.3);
        return c_white
    })
	
    use = method(self, function(spell_user, target, caller) {
        cutscene_enc_wait(true)
        cutscene_dialogue(loc_string("item_spell_cast", party_getname(spell_user), item_get_name(self)),, false)
    
        cutscene_sleep(10)
        cutscene_audio_play(snd_ghostappear)
        
        var __targets = []
        for (var i = 0; i < array_length(o_enc.encounter_data.enemies); i ++) {
            if !enc_enemy_is_fighting(i)
                continue
            
            var __e_obj = o_enc.encounter_data.enemies[i].actor_id
            var __success = o_enc.encounter_data.enemies[i].tired
            
            cutscene_instance_create(o_eff_sleepmist, 
                __e_obj.x, __e_obj.s_get_middle_y(), 
                __e_obj.depth - 10, {
                    success: __success
            })
            
            if !o_enc.encounter_data.enemies[i].tired
                continue
            
            array_push(__targets, i)
        }
        
        cutscene_spare_enemy(__targets)
        
        cutscene_sleep(30)
        cutscene_func(instance_destroy, [o_ui_dialogue])
		cutscene_enc_wait(false)
    });
    
    item_localize("item_s_sleepmist");
}
function item_s_iceshock() : item_spell() constructor {
	name = "IceShock";
	desc = ["Deal magical ICE damage to one enemy.", "Damage w/ ICE"];
	use_type = ITEM_USE.ENEMY;
	tp_cost = 16;
	
    use = method(self, function(spell_user, target, caller) {
        if !enc_enemy_is_fighting(target)
            exit
        
        var __e_obj = o_enc.encounter_data.enemies[target].actor_id
        cutscene_enc_wait(true)
    
        cutscene_dialogue(loc_string("item_spell_cast", party_getname(spell_user), item_get_name(self)),, false)
    
        cutscene_sleep(10)
        cutscene_audio_play(snd_icespell)
        cutscene_instance_create(o_eff_iceshock, __e_obj.x, __e_obj.s_get_middle_y(), __e_obj.depth - 20)
        
        cutscene_wait_until(function() {
            return !instance_exists(o_eff_iceshock)
        })
        cutscene_func(function(target, spell_user) {
            var __o = o_enc.encounter_data.enemies[target].actor_id
            var __dmg = round(max(1, party_getdata(spell_user, "magic") - 10) * 30 + 90 + random(10))
            var __fatal = ((o_enc.encounter_data.enemies[target].hp - __dmg) <= 0)
            
            if !__fatal 
                animate(1, 0, 5, "linear", __o, "flash")
            
            enc_hurt_enemy(target, __dmg, spell_user,,, "freeze")
        }, [target, spell_user])
        
        cutscene_sleep(30)
        cutscene_func(instance_destroy, [o_ui_dialogue])
		cutscene_enc_wait(false)
    });
    
    item_localize("item_s_iceshock");
}

function item_s_defaultaction(nname) : item_spell() constructor {
	name = loc_string("item_s_party_action_name", loc(party_getdata(nname, "action_letter")))
	desc = ["", "", loc("item_s_party_action_desc")]
	
	use_type = ITEM_USE.ENEMY
	is_party_act = true
	
	color = merge_color(party_getdata(nname, "color"), c_white, 0.5)
	tp_cost = 0
}