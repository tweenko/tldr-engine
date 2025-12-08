function item_spell() : item() constructor {
	type = ITEM_TYPE.SPELL
}

function item_s_act() : item_spell() constructor {
	name = [loc("spell_act_name")]
	desc = [loc("spell_act_desc"), "--"]
	
	tp_cost = 0
}
	
function item_s_rudebuster() : item_spell() constructor {
	name = [loc("spell_rude_buster_name")]
	desc = loc("spell_rude_buster_desc")
	use_type = ITEM_USE.ENEMY
	
    use = function(index, target, caller = -1) {
        var __name = global.party_names[index]
        var __e_obj = o_enc.encounter_data.enemies[target].actor_id
        
        cutscene_set_variable(o_enc, "waiting", true)
		cutscene_dialogue(string(loc("spell_cast"), party_getname(__name), string_upper(loc("spell_rude_buster_name"))),, false)
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
            
            animate(0, 1, 3, "linear", inst, "image_alpha")
        }, [__e_obj, party_get_inst(__name), target, __name])
        cutscene_sleep(50)
		cutscene_set_variable(o_enc, "waiting", false)
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
        
        name = [loc("spell_susieheal_name")[__prog]]
        desc = loc("spell_susieheal_desc")[__prog]
        
        self._data = __data
        use_args = [name[0], __heal_calc, function(){
            _data.uses ++
            __update_spell(_data)
        }]
    }
    
    use = function(index, target, caller, _name, _calc, _use) {
        var __name = global.party_names[index]
        
        cutscene_set_variable(o_enc, "waiting", true)
		cutscene_dialogue(string(loc("spell_cast"), party_getname(__name), _name),, false)
        
        cutscene_sleep(10)
        cutscene_func(function(index, target, _name, _calc, _use) {
            party_heal(global.party_names[target], _calc(global.party_names[index]))
            
            _use()
        }, [index, target, _name, _calc, _use])
        
        cutscene_sleep(30)
        cutscene_func(instance_destroy, [o_ui_dialogue])
		cutscene_set_variable(o_enc, "waiting", false)
    }
    
    __update_spell(_data)
}
	
function item_s_testdmg() : item_spell() constructor {
	name = ["Test Damage"]
	desc = ["Deals little damage to a foe.", "Test Damage"]
	use_type = ITEM_USE.ENEMY
	
	use = function() {
		cutscene_set_variable(o_enc, "waiting", true)
		cutscene_func(enc_hurt_enemy, [target, 10, user])
		cutscene_dialogue(string(loc("spell_cast"), party_getname(global.party_names[user]), "TEST DAMAGE"),, true)
		cutscene_set_variable(o_enc, "waiting", false)
	}
	
	tp_cost = 16
}

function item_s_pacify() : item_spell() constructor {
	name = [loc("spell_pacify_name")]
	desc = loc("spell_pacify_desc")
	
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
        
        cutscene_set_variable(o_enc, "waiting", true)
        
        if o_enc.encounter_data.enemies[target].tired {
		    cutscene_dialogue(string(loc("spell_cast"), party_getname(__name), _name),, false)
           
            cutscene_sleep(10)
            cutscene_instance_create(o_eff_pacify, __e_obj.x, __e_obj.y - __e_obj.myheight/2, __e_obj.depth - 10)
            cutscene_audio_play(snd_spell_pacify)
            cutscene_spare_enemy(target)
            
            cutscene_sleep(30)
        }
        else {
            cutscene_dialogue(string(loc("spell_pacify_desc")[2], party_getname(__name), _name),, false)
            
            cutscene_set_variable(__e_obj, "flash_color", c_blue)
            cutscene_sleep(20)
            cutscene_animate(0, .75, 7, "linear", __e_obj, "flash")
            cutscene_sleep(7)
            cutscene_animate(.75, 0, 7, "linear", __e_obj, "flash")
            cutscene_sleep(10)
            cutscene_set_variable(__e_obj, "flash_color", c_white)
        }
        
        cutscene_func(instance_destroy, [o_ui_dialogue])
		cutscene_set_variable(o_enc, "waiting", false)
    }
    use_args = [name[0]]
    
	tp_cost = 16
}
function item_s_healprayer() : item_spell() constructor {
	name = [loc("spell_heal_prayer_name")]
	desc = loc("spell_heal_prayer_desc")
	use_type = ITEM_USE.INDIVIDUAL
	
    use = function(index, target, caller, _name) {
        var __name = global.party_names[index]
        
        cutscene_set_variable(o_enc, "waiting", true)
		cutscene_dialogue(string(loc("spell_cast"), party_getname(__name), _name),, false)
        
        cutscene_sleep(10)
        cutscene_func(function(index, target, _name) {
            party_heal(global.party_names[target], party_getdata(global.party_names[index], "magic") * 5)
        }, [index, target, _name])
        
        cutscene_sleep(30)
        cutscene_func(instance_destroy, [o_ui_dialogue])
		cutscene_set_variable(o_enc, "waiting", false)
    }
    use_args = [name[0]]
    
	tp_cost = 32
}

function item_s_sleepmist() : item_spell() constructor {
    name = [loc("spell_sleep_mist_name")]
	desc = loc("spell_sleep_mist_desc")
	
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
        
        cutscene_set_variable(o_enc, "waiting", true)
    
        cutscene_dialogue(string(loc("spell_cast"), party_getname(__name), _name),, false)
    
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
		cutscene_set_variable(o_enc, "waiting", false)
    }
    use_args = [name[0]]
    
	tp_cost = 32
}
function item_s_iceshock() : item_spell() constructor {
	name = [loc("spell_iceshock_name")]
	desc = loc("spell_iceshock_desc")
	use_type = ITEM_USE.ENEMY
	
    use = function(index, target, caller, _name) {
        var __name = global.party_names[index]
        var __e_obj = o_enc.encounter_data.enemies[target].actor_id
        
        cutscene_set_variable(o_enc, "waiting", true)
    
        cutscene_dialogue(string(loc("spell_cast"), party_getname(__name), _name),, false)
    
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
                animate(1, 0, 5, "linear", __o, "flash")
            
            enc_hurt_enemy(target, __dmg, index,,, 20,, "freeze")
        }, [target, __name, index])
        
        cutscene_sleep(30)
        cutscene_func(instance_destroy, [o_ui_dialogue])
		cutscene_set_variable(o_enc, "waiting", false)
    }
    use_args = [name[0]]
    
	tp_cost = 16
}

function item_s_defaultaction(nname) : item_spell() constructor {
	name = string(loc("spell_party_action_name"), loc(party_getdata(nname, "action_letter")))
	desc = ["", "", loc("spell_party_action_desc")]
	
	use_type = ITEM_USE.ENEMY
	
	color = merge_color(party_getdata(nname, "color"), c_white, 0.5)
	tp_cost = 0
	is_party_act = true
}