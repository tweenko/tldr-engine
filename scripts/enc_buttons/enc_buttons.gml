function enc_button() constructor {
    sprite = -1 // will be determined by the name when __detemine_sprite is called
    
    // config
    name = "undefined"
    target_menu = BATTLE_MENU.BUTTON_SELECTION
    
    press = function(_tp) {
        with other {
            battle_menu_proceed = other.menu_proceed
            battle_menu_cancel = other.menu_cancel
        }
        return target_menu
    } // return the target battle menu enumerator, value recieves the tp to give (only for defend)
    
    menu_proceed = function() {} // called when inside the target menu and proceeded
    menu_cancel = function() {} // called when inside the target menu and canceled
    submit_action = function() {} // called when finishing the target menu and submitting the action
    
    __determine_sprite = function() {
        sprite = asset_get_index(string(loc("enc_ui_spr_buttons"), name))
    }
}

function enc_button_fight() : enc_button() constructor {
    name = "fight"
    target_menu = BATTLE_MENU.ENEMY_SELECTION
    
    menu_proceed = function() {
        var __party_members = [global.party_names[other.party_selection]]
        with other {
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
    }
    menu_cancel = function() {
        with other {
            battle_menu = BATTLE_MENU.BUTTON_SELECTION
            __enemy_highlight_reset()
        }
    }
    
    __determine_sprite()
}
function enc_button_act() : enc_button() constructor {
    name = "act"
    target_menu = BATTLE_MENU.ENEMY_SELECTION
    
    menu_proceed = function() {
        with other {
            battle_menu = BATTLE_MENU.INV_SELECTION
            battle_inv_menu_type = BATTLE_INV_MENU_TYPE.ACT
        }
    }
    menu_cancel = function() {
        with other {
            battle_menu = BATTLE_MENU.BUTTON_SELECTION
            __enemy_highlight_reset()
        }
    }
    submit_action = function(item_info) {
        var __party_members = [global.party_names[other.party_selection]]
        
        // add the acting party members
        if item_info.party == -1
            __party_members = variable_clone(global.party_names)
        else if is_array(item_info.party) && array_length(item_info.party) > 0
            for (var i = 0; i < array_length(item_info.party); i ++) {
                array_push(__party_members, item_info.party[i])
            }
        else if is_string(item_info.party)
            array_push(__party_members, item_info.party)
        
        with other {
            array_push(action_queue, new enc_action_act(__party_members, party_enemy_selection[party_selection], item_info))
            
            for (var i = 0; i < array_length(__party_members); i ++) {
                var index = party_get_index(__party_members[i])
                party_state[index] = PARTY_STATE.ACT
                enc_party_set_battle_sprite(__party_members[i], "actready")
                
                if __party_members[i] != global.party_names[party_selection] {
                    array_push(party_busy_internal, __party_members[i])
                }
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
    target_menu = BATTLE_MENU.INV_SELECTION
    
    __determine_sprite()
}
function enc_button_item() : enc_button() constructor {
    name = "item"
    target_menu = BATTLE_MENU.INV_SELECTION
    
    __determine_sprite()
}
function enc_button_spare() : enc_button() constructor {
    name = "spare"
    target_menu = BATTLE_MENU.ENEMY_SELECTION
    
    __determine_sprite()
}
function enc_button_defend() : enc_button() constructor {
    name = "defend"
    
    press = function(_tp) {
        with other {
            array_push(action_queue, new enc_action_defend(global.party_names[party_selection]))
            
            party_state[party_selection] = PARTY_STATE.DEFEND
            enc_party_set_battle_sprite(global.party_names[party_selection], "defend")
            
            party_selection ++
            tp += _tp
        }
        
        return BATTLE_MENU.BUTTON_SELECTION
    }
    
    __determine_sprite()
}