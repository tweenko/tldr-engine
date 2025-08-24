function item_spell() : item() constructor {
	type = ITEM_TYPE.SPELL
}

function item_s_act() : item_spell() constructor {
	name = ["ACT"]
	desc = ["You can do many things.\nDon't confuse it with magic.", "--"]
	
	tp_cost = 0
}
	
function item_s_rudebuster() : item_spell() constructor {
	name = ["Rude Buster"]
	desc = ["Deals moderate Rude-elemental damage to one foe. Depends on Attack & Magic.", "Rude Damage"]
	use_type = ITEM_USE.ENEMY
	
    use = function(index, target, caller = -1) {
        var __name = global.party_names[index]
        var __e_obj = o_enc.encounter_data.enemies[target].actor_id
        
        cutscene_set_variable(o_enc, "exec_waiting", true)
		cutscene_dialogue(string("* {0} used RUDE BUSTER!", party_getname(__name)),, false)
        cutscene_sleep(20)
        cutscene_set_partysprite(index, "rudebuster")
        cutscene_wait_until(function(__name) {
            return party_get_inst(__name).image_index >= 6
        }, [__name])
        cutscene_func(instance_destroy, [o_ui_dialogue])
        cutscene_func(function(tgt, m, _slot, name) {
            var inst = instance_create(o_eff_rudebuster, m.x + m.sprite_width/2 - 30, m.y - m.myheight/2, tgt.depth - 50)
            inst.target_x = tgt.x
            inst.target_y = tgt.y - tgt.myheight/2
            
            inst.enemy_o = tgt
            inst.slot = _slot
            inst.dmg = party_getdata(name, "attack") * 11 + party_getdata(name, "magic") * 5 - o_enc.encounter_data.enemies[_slot].defense * 3
            inst.user = name
            
            inst.image_angle = point_direction(inst.x, inst.y, tgt.x, tgt.y - tgt.myheight/2) - 20
            inst.speed = 12
            inst.friction = -1.5/2
            inst.direction = inst.image_angle
            
            do_animate(0, 1, 3, "linear", inst, "image_alpha")
        }, [__e_obj, party_get_inst(__name), target, __name])
        cutscene_sleep(50)
		cutscene_set_variable(o_enc, "exec_waiting", false)
    }
    
	tp_cost = 50
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
            name = ["UltimateHeal"]
            desc = ["Heals 1 party member to the best of Susie's ability.", "Best Healing"]
            
            tp_cost = 100
            __heal_calc = function(user) {
                return party_getdata(user, "magic") + 1
            }
        }
        else if __prog == 1 {
            name = ["UltraHeal"]
            desc = ["An awesome healing spell. ... right?", "Best Healing"]
            
            _data.uses = clamp(_data.uses, 0, 5)
            
            tp_cost = 90 - _data.uses
            __heal_calc = function(user) {
                return round(party_getdata(user, "magic") * 1.5 + 5) + _data.uses
            }
        }
        else if __prog == 2 {
            name = ["OKHeal"]
            desc = ["It's not the best healing spell, but it may have its uses.", "OK healing"]
            
            _data.uses = clamp(_data.uses, 0, 15)
            
            tp_cost = 85
            tp_cost -= clamp((_data.uses div 3) + 1, 0, 5)
            
            __heal_calc = function(user) {
                return round(party_getdata(user, "magic") * 5 + 15) + _data.uses*2
            }
        }
        else if __prog == 3 {
            name = ["BetterHeal"]
            desc = ["A healing spell that has grown with practice and confidence.", "Heal Ally"]
            
            _data.uses = clamp(_data.uses, 0, 15)
            
            tp_cost = 80
            tp_cost -= clamp((_data.uses div 3) + 1, 0, 5)
            
            __heal_calc = function(user) {
                return round(party_getdata(user, "magic") * 7 + 15) + _data.uses*2
            }
        }
        
        self._data = __data
        use_args = [name[0], __heal_calc, function(){
            _data.uses ++
            __update_spell(_data)
        }]
    }
    
    use = function(index, target, caller, _name, _calc, _use) {
        var __name = global.party_names[index]
        
        cutscene_set_variable(o_enc, "exec_waiting", true)
		cutscene_dialogue(string("* {0} cast {1}!", party_getname(__name), _name),, false)
        
        cutscene_sleep(10)
        cutscene_func(function(index, target, _name, _calc, _use) {
            party_heal(global.party_names[target], _calc(global.party_names[index]))
            
            _use()
        }, [index, target, _name, _calc, _use])
        
        cutscene_sleep(30)
        cutscene_func(instance_destroy, [o_ui_dialogue])
		cutscene_set_variable(o_enc, "exec_waiting", false)
    }
    
    __update_spell(_data)
}
	
function item_s_testdmg() : item_spell() constructor {
	name = ["Test Damage"]
	desc = ["Deals little damage to a foe.", "Test Damage"]
	use_type = ITEM_USE.ENEMY
	
	use = function() {
		cutscene_set_variable(o_enc, "exec_waiting", true)
		cutscene_func(enc_hurt_enemy, [target, 10, user])
		cutscene_dialogue(string("* {0} cast TEST DAMAGE!", party_getname(global.party_names[user])),, true)
		cutscene_set_variable(o_enc, "exec_waiting", false)
	}
	
	tp_cost = 16
}

function item_s_pacify() : item_spell() constructor {
	name = ["Pacify"]
	desc = ["SPARE a tired enemy by putting them to sleep.", "Spare TIRED foe"]
	
	use_type = ITEM_USE.ENEMY
	is_mercyspell = true
	color = function() {
        var _do = false
        
        for (var i = 0; i < array_length(o_enc.encounter_data.enemies); i ++) {
            if !enc_enemy_isfighting(i)
                continue
            
            if o_enc.encounter_data.enemies[i].tired {
                _do = true
                break
            }
        }
        
        if _do
            return merge_color(c_aqua, c_blue, 0.3)
        return c_white
    }
	
    use = function(index, target, caller, _name) {
        var __name = global.party_names[index]
        var __e_obj = o_enc.encounter_data.enemies[target].actor_id
        
        cutscene_set_variable(o_enc, "exec_waiting", true)
        
        if o_enc.encounter_data.enemies[target].tired {
		    cutscene_dialogue(string("* {0} cast {1}!", party_getname(__name), _name),, false)
           
            cutscene_sleep(10)
            cutscene_instance_create(o_eff_pacify, __e_obj.x, __e_obj.y - __e_obj.myheight/2, __e_obj.depth - 10)
            cutscene_audio_play(snd_spell_pacify)
            cutscene_spare_enemy(target)
        }
        else {
            cutscene_dialogue(string("* {0} cast {1}!{br}{resetx}{sleep(10)}* But the enemy wasn't {col(tired_aqua)}TIRED{reset_col}...", party_getname(__name), _name),, false)
            
            cutscene_set_variable(__e_obj, "flash_color", c_blue)
            cutscene_sleep(20)
            cutscene_animate(0, .75, 7, "linear", __e_obj, "flash")
            cutscene_sleep(7)
            cutscene_animate(.75, 0, 7, "linear", __e_obj, "flash")
            cutscene_sleep(10)
            cutscene_set_variable(__e_obj, "flash_color", c_white)
            cutscene_sleep(20)
        }
        
        cutscene_sleep(30)
        cutscene_func(instance_destroy, [o_ui_dialogue])
		cutscene_set_variable(o_enc, "exec_waiting", false)
    }
    use_args = [name[0]]
    
	tp_cost = 16
}
function item_s_healprayer() : item_spell() constructor {
	name = ["Heal Prayer"]
	desc = ["Heavenly Light restores a little HP to\none party member. Depends on Magic.", "Heal Ally"]
	use_type = ITEM_USE.INDIVIDUAL
	
    use = function(index, target, caller, _name) {
        var __name = global.party_names[index]
        
        cutscene_set_variable(o_enc, "exec_waiting", true)
		cutscene_dialogue(string("* {0} cast {1}!", party_getname(__name), _name),, false)
        
        cutscene_sleep(10)
        cutscene_func(function(index, target, _name) {
            party_heal(global.party_names[target], party_getdata(global.party_names[index], "magic") * 5)
        }, [index, target, _name])
        
        cutscene_sleep(30)
        cutscene_func(instance_destroy, [o_ui_dialogue])
		cutscene_set_variable(o_enc, "exec_waiting", false)
    }
    use_args = [name[0]]
    
	tp_cost = 32
}

function item_s_sleepmist() : item_spell() constructor {
    name = ["Sleep Mist"]
	desc = ["A cold mist sweeps through, sparing all TIRED enemies.", "Spare TIRED foes"]
	
	use_type = ITEM_USE.EVERYONE
	is_mercyspell = true
    
	color = function() {
        var _do = false
        
        for (var i = 0; i < array_length(o_enc.encounter_data.enemies); i ++) {
            if !enc_enemy_isfighting(i)
                continue
            
            if o_enc.encounter_data.enemies[i].tired {
                _do = true
                break
            }
        }
        
        if _do
            return merge_color(c_aqua, c_blue, 0.3)
        return c_white
    }
	
    use = function(index, target, caller, _name) {
        var __name = global.party_names[index]
        
        cutscene_set_variable(o_enc, "exec_waiting", true)
    
        cutscene_dialogue(string("* {0} cast {1}!", party_getname(__name), _name),, false)
    
        cutscene_sleep(10)
        cutscene_audio_play(snd_ghostappear)
        
        var __targets = []
        for (var i = 0; i < array_length(o_enc.encounter_data.enemies); i ++) {
            var __e_obj = o_enc.encounter_data.enemies[i].actor_id
            var __success = o_enc.encounter_data.enemies[i].tired
            
            if !enc_enemy_isfighting(i)
                continue
            
            cutscene_instance_create(o_eff_sleepmist, 
                __e_obj.x, __e_obj.y - __e_obj.myheight/2, 
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
		cutscene_set_variable(o_enc, "exec_waiting", false)
    }
    use_args = [name[0]]
    
	tp_cost = 32
}
function item_s_iceshock() : item_spell() constructor {
	name = ["IceShock"]
	desc = ["Deal magical ICE damage to one enemy.", "Damage w/ ICE"]
	use_type = ITEM_USE.ENEMY
	
    use = function(index, target, caller, _name) {
        var __name = global.party_names[index]
        var __e_obj = o_enc.encounter_data.enemies[target].actor_id
        
        cutscene_set_variable(o_enc, "exec_waiting", true)
    
        cutscene_dialogue(string("* {0} cast {1}!", party_getname(__name), _name),, false)
    
        cutscene_sleep(10)
        cutscene_audio_play(snd_icespell)
        cutscene_instance_create(o_eff_iceshock, __e_obj.x, __e_obj.y - __e_obj.myheight/2, __e_obj.depth - 20)
        
        cutscene_wait_until(function() {
            return !instance_exists(o_eff_iceshock)
        })
        cutscene_func(function(target, __name, index) {
            var __o = o_enc.encounter_data.enemies[target].actor_id
            var __dmg = round(max(1, party_getdata(__name, "magic") - 10) * 30 + 90 + random(10))
            var __fatal = ((o_enc.encounter_data.enemies[target].hp - __dmg) <= 0)
            
            if !__fatal 
                do_animate(1, 0, 5, "linear", __o, "flash")
            else 
                instance_create(o_text_hpchange, __o.x, __o.y - __o.myheight/2, __o.depth - 100, {
                    draw: "frozen",
                    mode: 4,
                })
            
            enc_hurt_enemy(target, __dmg, index,,, 20,, "freeze")
        }, [target, __name, index])
        
        cutscene_sleep(30)
        cutscene_func(instance_destroy, [o_ui_dialogue])
		cutscene_set_variable(o_enc, "exec_waiting", false)
    }
    use_args = [name[0]]
    
	tp_cost = 16
}

function item_s_defaultaction(nname) : item_spell() constructor {
	name = string("{0}-Action", string_upper(string_copy(nname, 0, 1)))
	desc = ["", "", "Standard"]
	
	use_type = ITEM_USE.ENEMY
	
	color = merge_color(party_getdata(nname, "color"), c_white, 0.5)
	tp_cost = 0
	is_party_act = true
}