function enc_button() constructor {
    sprite = -1 // will be determined by the name when __detemine_sprite is called
    
    // config
    name = "undefined"
    target_menu = BATTLE_MENU.BUTTON_SELECTION
    
    press = function() {}
    submit_action = function() {} // called when finishing the target menu and submitting the action
    
    __determine_sprite = function() { // internal
        sprite = asset_get_index(string(loc("enc_ui_spr_buttons"), name))
    }
}

function enc_button_fight() : enc_button() constructor {
    name = "fight"
    press = function(_tp) {
        audio_play(snd_ui_select)
        with other {
            battle_menu = BATTLE_MENU.ENEMY_SELECTION
            __enemy_highlight(party_enemy_selection[party_selection])
            
            battle_menu_enemy_proceed = function() {
                audio_play(snd_ui_select)
                
                var __party_members = [global.party_names[other.party_selection]]
                array_push(action_queue, new enc_action_fight(__party_members[0], party_enemy_selection[party_selection]))
                
                for (var i = 0; i < array_length(__party_members); i ++) {
                    var index = party_get_index(__party_members[i])
                    party_state[index] = PARTY_STATE.FIGHT
                    enc_party_set_battle_sprite(__party_members[i], "attackready")
                    
                    if __party_members[i] != global.party_names[party_selection]
                        array_push(party_busy_internal, __party_members[i])
                }
                
                party_selection ++
                battle_menu = BATTLE_MENU.BUTTON_SELECTION
                __enemy_highlight_reset()
            }
            battle_menu_enemy_cancel = function() {
                battle_menu = BATTLE_MENU.BUTTON_SELECTION
                __enemy_highlight_reset()
            }
        }
    }
    
    __determine_sprite()
}
function enc_button_act() : enc_button() constructor {
    name = "act"
    press = function() {
        audio_play(snd_ui_select)
        with other {
            battle_menu = BATTLE_MENU.ENEMY_SELECTION
            __enemy_highlight(party_enemy_selection[party_selection])
            
            battle_menu_enemy_proceed = function() {
                audio_play(snd_ui_select)
                
                battle_menu = BATTLE_MENU.INV_SELECTION
                battle_menu_inv_list = __act_sort(party_enemy_selection[party_selection])
                battle_menu_inv_var_name = "party_act_selection"
                battle_menu_inv_page_var_name = "party_act_page"
                battle_menu_inv_var_operate = function(_delta, _abs = false) {
                    if _abs     party_act_selection[party_selection] = _delta
                    else        party_act_selection[party_selection] += _delta
                }
                
                battle_menu_inv_proceed = function(item_struct) {
                    var __button = party_buttons[party_selection][party_button_selection[party_selection]]
                    
                    var can_perform = true
                    // disable the act if some member is not up
                    if item_struct.party == -1 {
                        for (var j = 0; j < array_length(global.party_names); j ++) {
                            if !party_isup(global.party_names[j]) {
                                can_perform = false
                                break
                            }
                        }
                    }
                    else {
                        for (var j = 0; j < array_length(item_struct.party); j ++) {
                            var name = item_struct.party[j]
                            if !party_isup(name) {
                                can_perform = false
                                break
                            }
                        }
                    }
                    if struct_exists(item_struct, "tp_cost") {
                        if item_struct.tp_cost > tp
                            can_perform = false
                    }
                    
                    if can_perform {
                        audio_play(snd_ui_select)
                        __button.submit_action(item_struct)
                    }
                }
                battle_menu_inv_cancel = function() {
                    battle_menu = BATTLE_MENU.ENEMY_SELECTION
                    __enemy_highlight(party_enemy_selection[party_selection])
                }
            }
            battle_menu_enemy_cancel = function() {
                battle_menu = BATTLE_MENU.BUTTON_SELECTION
                __enemy_highlight_reset()
            }
        }
    }
    submit_action = function(item_struct) {
        var __party_members = [global.party_names[other.party_selection]]
        
        // add the acting party members
        if struct_exists(item_struct, "party") {
            if item_struct.party == -1
                __party_members = variable_clone(global.party_names)
            else if is_array(item_struct.party) && array_length(item_struct.party) > 0
                for (var i = 0; i < array_length(item_struct.party); i ++) {
                    array_push(__party_members, item_struct.party[i])
                }
            else if is_string(item_struct.party)
                array_push(__party_members, item_struct.party)
        }
        
        with other {
            array_push(action_queue, new enc_action_act(__party_members, party_enemy_selection[party_selection], item_struct))
            if struct_exists(item_struct, "tp_cost")
                tp -= item_struct.tp_cost
            
            for (var i = 0; i < array_length(__party_members); i ++) {
                var index = party_get_index(__party_members[i])
                party_state[index] = PARTY_STATE.ACT
                enc_party_set_battle_sprite(__party_members[i], "actready")
                
                if __party_members[i] != global.party_names[party_selection]
                    array_push(party_busy_internal, __party_members[i])
            }
            
            party_selection ++
            battle_menu = BATTLE_MENU.BUTTON_SELECTION
            __enemy_highlight_reset()
        }
    }
    
    __determine_sprite()
}
function enc_button_power() : enc_button() constructor {
    name = "power"
    press = function() {
        audio_play(snd_ui_select)
        with other {
            battle_menu = BATTLE_MENU.INV_SELECTION
            
            battle_menu_inv_list = __spell_sort(global.party_names[party_selection])
            battle_menu_inv_var_name = "party_spell_selection"
            battle_menu_inv_page_var_name = "party_spell_page"
            battle_menu_inv_var_operate = function(_delta, _abs = false) {
                if _abs     party_spell_selection[party_selection] = _delta
                else        party_spell_selection[party_selection] += _delta
            }
            
            battle_menu_inv_proceed = function(spell_struct) {
                var can_perform = true
                if struct_exists(spell_struct, "tp_cost") {
                    if spell_struct.tp_cost > tp
                        can_perform = false
                }
                
                if can_perform {
                    audio_play(snd_ui_select)
                    switch spell_struct.use_type {
                        case ITEM_USE.EVERYONE: // continue right away
                            var __button = party_buttons[party_selection][party_button_selection[party_selection]]
                            __button.submit_action(spell_struct, -1)
                            break
                        case ITEM_USE.INDIVIDUAL: // let the player choose an ally
                            battle_menu = BATTLE_MENU.PARTY_SELECTION
                            __ally_highlight(party_ally_selection[party_selection])
                            
                            battle_menu_party_proceed = function() {
                                audio_play(snd_ui_select)
                                
                                var __button = party_buttons[party_selection][party_button_selection[party_selection]]
                                var __target_spell = battle_menu_inv_list[party_spell_selection[party_selection]]
                                __button.submit_action(__target_spell, party_ally_selection[party_selection])
                            }
                            battle_menu_party_cancel = function() {
                                battle_menu = BATTLE_MENU.INV_SELECTION
                                __ally_highlight_reset()
                            }
                            break
                        case ITEM_USE.ENEMY: // let the player choose a target enemy
                            battle_menu = BATTLE_MENU.ENEMY_SELECTION
                            __enemy_highlight(party_enemy_selection[party_selection])
                            
                            battle_menu_enemy_proceed = function() {
                                audio_play(snd_ui_select)
                                
                                var __button = party_buttons[party_selection][party_button_selection[party_selection]]
                                var __target_spell = battle_menu_inv_list[party_spell_selection[party_selection]]
                                __button.submit_action(__target_spell, party_enemy_selection[party_selection])
                            }
                            battle_menu_enemy_cancel = function() {
                                battle_menu = BATTLE_MENU.INV_SELECTION
                                __enemy_highlight_reset()
                            }
                            break
                    }
                }
            }
            battle_menu_inv_cancel = function() {
                battle_menu = BATTLE_MENU.BUTTON_SELECTION
            }
        }
    }
    submit_action = function(spell_struct, target) {
        var __party_members = [global.party_names[other.party_selection]]
        with other {
            array_push(action_queue, new enc_action_power(__party_members, target, spell_struct, party_spell_selection[party_selection]))
            tp -= spell_struct.tp_cost
            
            for (var i = 0; i < array_length(__party_members); i ++) {
                var index = party_get_index(__party_members[i])
                
                if spell_struct.is_party_act {
                    party_state[index] = PARTY_STATE.ACT
                    enc_party_set_battle_sprite(__party_members[i], "actready")
                }
                else {
                    party_state[index] = PARTY_STATE.POWER
                    enc_party_set_battle_sprite(__party_members[i], "spellready")
                }
                
                if __party_members[i] != global.party_names[party_selection]
                    array_push(party_busy_internal, __party_members[i])
            }
            
            party_selection ++
            battle_menu = BATTLE_MENU.BUTTON_SELECTION
            __enemy_highlight_reset()
            __ally_highlight_reset()
        }
    }
    
    __determine_sprite()
}
function enc_button_item() : enc_button() constructor {
    name = "item"
    press = function() {
        if array_length(other.__item_sort()) == 0 {
            audio_play(snd_ui_cant_select)
            return
        }
        else
            audio_play(snd_ui_select)
        
        with other {
            battle_menu = BATTLE_MENU.INV_SELECTION
            
            battle_menu_inv_list = __item_sort()
            battle_menu_inv_var_name = "party_item_selection"
            battle_menu_inv_page_var_name = "party_item_page"
            battle_menu_inv_var_operate = function(_delta, _abs = false) {
                if _abs     party_item_selection[party_selection] = _delta
                else        party_item_selection[party_selection] += _delta
            }
            
            battle_menu_inv_proceed = function(item_struct) {
                var can_perform = true
                if struct_exists(item_struct, "tp_cost") {
                    if item_struct.tp_cost > tp
                        can_perform = false
                }
                
                if can_perform {
                    audio_play(snd_ui_select)
                    switch item_struct.use_type {
                        case ITEM_USE.EVERYONE: // continue right away
                            var __button = party_buttons[party_selection][party_button_selection[party_selection]]
                            __button.submit_action(item_struct, -1)
                            break
                        case ITEM_USE.INDIVIDUAL: // let the player choose an ally
                            battle_menu = BATTLE_MENU.PARTY_SELECTION
                            __ally_highlight(party_ally_selection[party_selection])
                            
                            battle_menu_party_proceed = function() {
                                audio_play(snd_ui_select)
                                
                                var __button = party_buttons[party_selection][party_button_selection[party_selection]]
                                var __target_spell = battle_menu_inv_list[party_spell_selection[party_selection]]
                                __button.submit_action(__target_spell, party_ally_selection[party_selection])
                            }
                            battle_menu_party_cancel = function() {
                                battle_menu = BATTLE_MENU.INV_SELECTION
                                __ally_highlight_reset()
                            }
                            break
                        case ITEM_USE.ENEMY: // let the player choose a target enemy
                            battle_menu = BATTLE_MENU.ENEMY_SELECTION
                            __enemy_highlight(party_enemy_selection[party_selection])
                            
                            battle_menu_enemy_proceed = function() {
                                audio_play(snd_ui_select)
                                
                                var __button = party_buttons[party_selection][party_button_selection[party_selection]]
                                var __target_spell = battle_menu_inv_list[party_spell_selection[party_selection]]
                                __button.submit_action(__target_spell, party_enemy_selection[party_selection])
                            }
                            battle_menu_enemy_cancel = function() {
                                battle_menu = BATTLE_MENU.INV_SELECTION
                                __enemy_highlight_reset()
                            }
                            break
                    }
                }
            }
            battle_menu_inv_cancel = function() {
                battle_menu = BATTLE_MENU.BUTTON_SELECTION
            }
        }
    }
    submit_action = function(item_struct, target) {
        var __party_members = [global.party_names[other.party_selection]]
        with other {
            array_push(action_queue, new enc_action_item(__party_members, target, item_struct, party_item_selection[party_selection]))
            array_push(items_using, party_item_selection[party_selection])
            tp -= item_struct.tp_cost
            
            for (var i = 0; i < array_length(__party_members); i ++) {
                var index = party_get_index(__party_members[i])
                
                party_state[index] = PARTY_STATE.ITEM
                enc_party_set_battle_sprite(__party_members[i], "itemready")
                
                if __party_members[i] != global.party_names[party_selection]
                    array_push(party_busy_internal, __party_members[i])
            }
            
            party_selection ++
            battle_menu = BATTLE_MENU.BUTTON_SELECTION
            __enemy_highlight_reset()
            __ally_highlight_reset()
        }
    }
    
    __determine_sprite()
}
function enc_button_spare() : enc_button() constructor {
    name = "spare"
    press = function(_tp) {
        audio_play(snd_ui_select)
        with other {
            battle_menu = BATTLE_MENU.ENEMY_SELECTION
            __enemy_highlight(party_enemy_selection[party_selection])
            
            battle_menu_enemy_proceed = function() {
                audio_play(snd_ui_select)
                
                array_push(action_queue, new enc_action_spare(global.party_names[other.party_selection], other.party_enemy_selection[other.party_selection]))
                enc_party_set_battle_sprite(global.party_names[other.party_selection], "actready")
                other.party_state[other.party_selection] = PARTY_STATE.SPARE
                
                party_selection ++
                battle_menu = BATTLE_MENU.BUTTON_SELECTION
                __enemy_highlight_reset()
            }
            battle_menu_enemy_cancel = function() {
                battle_menu = BATTLE_MENU.BUTTON_SELECTION
                __enemy_highlight_reset()
            }
        }
    }
    
    __determine_sprite()
}
function enc_button_defend() : enc_button() constructor {
    name = "defend"
    press = function() {
        audio_play(snd_ui_select)
        with other {
            battle_menu = BATTLE_MENU.BUTTON_SELECTION
            array_push(action_queue, new enc_action_defend(global.party_names[party_selection]))
            
            party_state[party_selection] = PARTY_STATE.DEFEND
            enc_party_set_battle_sprite(global.party_names[party_selection], "defend")
            
            party_selection ++
            tp += tp_defend
        }
    }
    
    __determine_sprite()
}