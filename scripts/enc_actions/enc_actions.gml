/// @arg {string|array<string>} _party_names name/names of party members who will perform the action
function enc_action(_party_names) constructor {
    party_names = variable_clone(_party_names) // can be array/string
    acting_member = (is_array(_party_names) ? _party_names[0] : _party_names)
    other_members = []
    if is_array(_party_names)
        array_copy(other_members, 0, _party_names, 1, array_length(_party_names))
    
    target = -1
    
    cancel = function() {
        with other {
            if is_array(other.party_names) {
                for (var i = 0; i < array_length(other.party_names); i ++) {
                    party_state[party_get_index(other.party_names[i])] = PARTY_STATE.IDLE
                    enc_party_set_battle_sprite(other.party_names[i], "idle")
                    
                    if array_contains(party_busy_internal, other.party_names[i])
                        array_delete(party_busy_internal, array_get_index(party_busy_internal, other.party_names[i]), 1)
                }
            }
            else {
                party_state[party_get_index(other.party_names)] = PARTY_STATE.IDLE
                enc_party_set_battle_sprite(other.party_names, "idle")
                
                if array_contains(party_busy_internal, other.party_names)
                    array_delete(party_busy_internal, array_get_index(party_busy_internal, other.party_names), 1)
            }
        }
        cancel_effects()
    }
    /// @desc called together with the cancel method
    cancel_effects = function() {}
    
    /// @desc the function that will be called when the action is performed during action execution
    perform = function() {}
}

/// @arg {string|array<string>} _party_names name/names of party members who will perform the action
/// @arg {real} _enemy_target index of the target enemy
function enc_action_fight(_party_names, _enemy_target) : enc_action(_party_names) constructor {
    target = _enemy_target
    
    perform = function(_action_queue) {
        var names = [acting_member]
        var targets = [target]
        for (var i = array_length(_action_queue)-1; i >= 0; i --) {
            if is_instanceof(_action_queue[i], enc_action_fight) {
                array_push(names, _action_queue[i].party_names)
                array_push(targets, _action_queue[i].target)
                array_delete(_action_queue, i, 1)
            }
        }
        
        with other {
            action_queue = _action_queue
            instance_create(o_enc_fight,,,, {
                caller: id, 
                depth: depth-1, 
                fighting: names, 
                fighterselection: targets,
            })
            waiting_internal = true
        }
    }
}

/// @arg {string|array<string>} _party_names name/names of party members who will perform the action
/// @arg {real} _enemy_target index of the target enemy
/// @arg {struct} _act act struct
function enc_action_act(_party_names, _enemy_target, _act) : enc_action(_party_names) constructor {
    target = _enemy_target
    target_act = _act
    tp_taken = (struct_exists(_act, "tp_cost") ? _act.tp_cost : 0)
    
    perform = function(_action_queue) {
        if enc_enemy_isfighting(target) {
            // set the party sprites accordingly
            if !struct_exists(target_act, "perform_act_anim") 
                || (struct_exists(target_act, "perform_act_anim") && target_act.perform_act_anim)
            {
                for (var i = 0; i < array_length(party_names); i ++) {
                    enc_party_set_battle_sprite(party_names[i], "act")
                }
            }
        
            // perform the act
            var exec_args = []
            var back_to_idle = (struct_exists(target_act, "return_to_idle_sprites") ? target_act.return_to_idle_sprites : true)
            if struct_exists(target_act, "exec_args")
                exec_args = target_act.exec_args
            
            method_call(target_act.exec, array_concat([target, acting_member], exec_args))
            
            cutscene_create()
            cutscene_wait_until(function() {
                return !o_enc.__check_waiting()
            })
            cutscene_func(function(party_names, back_to_idle) {
                for (var i = 0; i < array_length(party_names); i ++) {
                    var p_inst = party_get_inst(party_names[i])
                    
                    if instance_exists(p_inst) {
                        if p_inst.sprname == "act"
                            enc_party_set_battle_sprite(party_names[i], "actend")
                        else if back_to_idle
                            enc_party_set_battle_sprite(party_names[i], "idle")
                    } 
                    
                    o_enc.party_state[party_get_index(party_names[i])] = PARTY_STATE.IDLE
                }
            }, [party_names, back_to_idle])
            cutscene_play()
        }
    }
    cancel_effects = function() {
        with other
            tp += other.tp_taken
    }
}

/// @arg {string|array<string>} _party_names name/names of party members who will perform the action
/// @arg {real} _target index of the target
/// @arg {struct.item_spell} _spell the spell struct
/// @arg {real} _spell_index the spell index
function enc_action_power(_party_names, _target, _spell, _spell_index) : enc_action(_party_names) constructor {
    target = _target
    target_spell = _spell
    target_spell_index = _spell_index
    tp_taken = _spell.tp_cost
    
    perform = function(_action_queue) {
        // find other enemies if the target is not fighting
        if target_spell.use_type == ITEM_USE.ENEMY {
            if !enc_enemy_isfighting(target)
                for (var i = 0; i < array_length(o_enc.encounter_data.enemies); ++i) {
                    if enc_enemy_isfighting(i) {
                        target = i
                        break
                    }
                }
            if !enc_enemy_isfighting(target)
                exit
        }
        
        cutscene_create()
        cutscene_set_variable(o_enc, "waiting_internal", true)
        
        if target_spell.is_party_act {
            var target_act = -1
            with o_enc
                target_act = encounter_data.enemies[party_enemy_selection[party_get_index(other.acting_member)]].acts_special
            
            // set the party sprites accordingly
            if struct_exists(target_act, "perform_act_anim") && target_act.perform_act_anim {
                for (var i = 0; i < array_length(party_names); i ++) {
                    enc_party_set_battle_sprite(party_names[i], "act")
                }
            }
           
            var __default_action = true
            if struct_exists(target_act, acting_member){
                target_act = struct_get(target_act, acting_member)
                if struct_exists(target_act, "exec") {
                    method_call(target_act.exec, [
                        other.party_enemy_selection[party_get_index(acting_member)], 
                        acting_member 
                    ])
                    __default_action = false
                }
            }
            
            if __default_action
                cutscene_dialogue($"* Default {party_getname(global.party_names[party_get_index(acting_member)])} Action")
        }
        else {
            // set the party sprites accordingly
            for (var i = 0; i < array_length(party_names); i ++) {
                enc_party_set_battle_sprite(party_names[i], "spell")
            }
            
            item_spell_use(target_spell, acting_member, target) // creates a cutscene
        }
        
        cutscene_sleep(4)
        
        cutscene_wait_until(function() {
            return !o_enc.waiting
        })
        cutscene_func(function(party_names) {
            for (var i = 0; i < array_length(party_names); i ++) {
                var p_inst = party_get_inst(party_names[i])
                if instance_exists(p_inst) && party_get_inst(party_names[i]).sprite_index == enc_getparty_sprite(party_names[i], "act")
                    enc_party_set_battle_sprite(party_names[i], "actend")
                o_enc.party_state[party_get_index(party_names[i])] = PARTY_STATE.IDLE
            }
        }, [party_names])
        
        cutscene_set_variable(o_enc, "waiting_internal", false)
        cutscene_play()
    }
    cancel_effects = function() {
        with other
            tp += other.tp_taken
    }
}

/// @arg {string|array<string>} _party_names name/names of party members who will perform the action
/// @arg {real} _target index of the target
/// @arg {struct.item} _item the item struct
/// @arg {real} _item_index the index of the item
function enc_action_item(_party_names, _target, _item, _item_index) : enc_action(_party_names) constructor {
    target = _target
    target_item = _item
    item_index = _item_index
    tp_taken = _item.tp_cost
    
    perform = function(_action_queue) {
        // set the party sprites accordingly
        for (var i = 0; i < array_length(party_names); i ++) {
            enc_party_set_battle_sprite(party_names[i], "itemuse")
        }
        
        // find other enemies if the target is not fighting
        if target_item.use_type == ITEM_USE.ENEMY {
            if !enc_enemy_isfighting(target)
                for (var i = 0; i < array_length(o_enc.encounter_data.enemies); ++i) {
                    if enc_enemy_isfighting(i) {
                        target = i
                        break
                    }
                }
            if !enc_enemy_isfighting(target)
                exit
        }
        
        cutscene_create()
        cutscene_set_variable(o_enc, "waiting_internal", true)
        
        cutscene_sleep(4)
        cutscene_dialogue(string(loc("item_use"), 
            party_getname(acting_member), 
            string_upper(item_get_name(target_item))), 
            "{s(20)}{p}{e}", false
        )
        
        cutscene_func(function(target_item, item_index, target) {
            with o_enc
                item_use(target_item, item_index, target)
        }, [target_item, item_index, target])
        
        // only continue when the item use animation is finished
        cutscene_wait_until(function(acting_member) {
            return party_get_inst(acting_member).sprname == "idle"
        }, [acting_member])
        
        cutscene_func(function(party_names) { // go back to idle
            for (var i = 0; i < array_length(party_names); i ++) {
                o_enc.party_state[party_get_index(party_names[i])] = PARTY_STATE.IDLE
            }
        }, [party_names])
        cutscene_sleep(30)
        
        cutscene_wait_until(function() {
            return !o_enc.waiting && !instance_exists(o_ui_dialogue)
        })
        cutscene_set_variable(o_enc, "waiting_internal", false)
        cutscene_play()
    }
    cancel_effects = function() {
        with other {
            tp += other.tp_taken
            array_pop(items_using)
        }
    }
}

/// @arg {string|array<string>} _party_names name/names of party members who will perform the action
/// @arg {real} _enemy_target index of the target enemy
function enc_action_spare(_party_names, _enemy_target) : enc_action(_party_names) constructor {
    target = _enemy_target
    perform = function(_action_queue) {
        if !enc_enemy_isfighting(target) // find another enemy to spare if this enemy is already spared
            for (var i = 0; i < array_length(o_enc.encounter_data.enemies); ++i) {
                if enc_enemy_isfighting(i) {
                    target = i
                    if o_enc.encounter_data.enemies[i].mercy >= 100
                        break
                }
            }
        if !enc_enemy_isfighting(target)
            exit
        
        with other {
            var __enemy = o_enc.encounter_data.enemies[other.target]
            
            waiting_internal = true
            enc_party_set_battle_sprite(other.acting_member, "spare")
            
            cutscene_create()
            
            if o_enc.encounter_data.enemies[other.target].mercy >= 100 { // can spare
                cutscene_dialogue(string(loc("enc_exec_spare_msg"), party_getname(other.acting_member), __enemy.name), "{s(20)}{p}{e}", false)
                cutscene_wait_until(function(member_name) {
                    return party_get_inst(member_name).sprname == "idle"
                }, [other.acting_member])
                
                cutscene_func(function(user) {
                    o_enc.party_state[user] = PARTY_STATE.IDLE
                }, [party_get_index(other.acting_member)])
                
                cutscene_spare_enemy(other.target)
                
                cutscene_sleep(30)
                cutscene_wait_until(function() {
                    return !instance_exists(o_ui_dialogue)
                })
                cutscene_set_variable(o_enc, "waiting_internal", false)
            }
            else {
                var txt = loc("enc_exec_spare_msg") + "{br}{resetx}" + loc("enc_exec_spare_notyellow")
                
                if __enemy.tired {
                    var tgt_spell = -1
                    var spellowner = ""
                    for (var i = 0; i < array_length(global.party_names); ++i) { // if party has a person who can use a mercy spell
                        for (var j = 0; j < array_length(party_getdata(global.party_names[i], "spells")); ++j) {
                            if party_getdata(global.party_names[i], "spells")[j].is_mercyspell {
                                tgt_spell = party_getdata(global.party_names[i], "spells")[j]
                                spellowner = party_getname(global.party_names[i])
                                break
                            }
                        }
                        if is_struct(tgt_spell) {
                            break
                        }
                    }
                    if is_struct(tgt_spell) { // if mercyspell exists
                        txt += "{p}{c}"
                        txt += string(loc("enc_exec_spare_suggest_spell"), spellowner, string_upper(item_get_name(tgt_spell)))
                    }
                }
                if __enemy.can_spare && __enemy.mercy_add_pity_percent > 0 // add pity spare percentage
                    cutscene_func(enc_enemy_add_spare, [other.target, __enemy.mercy_add_pity_percent])
                
                cutscene_dialogue(string(txt, party_getname(other.acting_member), __enemy.name),, true)
                cutscene_set_variable(o_enc, "waiting_internal", false)
            } 
            
            cutscene_play()
        }
    }
}
function enc_action_defend(_party_names) : enc_action(_party_names) constructor {
    tp_given = other.tp_defend
    cancel_effects = function() {
        with other
            tp -= other.tp_given
    }
}