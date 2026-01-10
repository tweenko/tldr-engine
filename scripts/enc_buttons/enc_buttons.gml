function enc_button() constructor {
    sprite = -1 // will be determined by the name
    
    // config
    name = "undefined"
    press = function(_tp) {} // return the target battle menu enumerator, value recieves the tp to give (only for defend)
    menu_proceed = function() {}
    menu_cancel = function() {}
    
    __determine_sprite = function() {
        sprite = asset_get_index(string(loc("enc_ui_spr_buttons"), name))
    }
}

function enc_button_fight() : enc_button() constructor {
    name = "fight"
    press = function(_tp) {
        return BATTLE_MENU.ENEMY_SELECTION
    }
    menu_proceed = function() {
        var targets = [global.party_names[other.party_selection]]
        
        with other {
            array_push(action_queue, new enc_action_fight(targets, party_enemy_selection[party_selection]))
            
            for (var i = 0; i < array_length(targets); i ++) {
                var index = party_get_index(targets[i])
                party_state[index] = PARTY_STATE.FIGHT
                enc_party_set_battle_sprite(targets[i], "attackready")
                
                if targets[i] != global.party_names[party_selection]
                    array_push(party_busy_internal, targets[i])
            }
            
            party_selection ++
            battle_menu = BATTLE_MENU.BUTTON_SELECTION
        }
    }
    menu_cancel = function() {
        with other
            battle_menu = BATTLE_MENU.BUTTON_SELECTION
    }
    
    __determine_sprite()
}
function enc_button_act() : enc_button() constructor {
    name = "act"
    press = function(_tp) {
        return BATTLE_MENU.ACT_SELECTION
    }
    
    __determine_sprite()
}
function enc_button_power() : enc_button() constructor {
    name = "power"
    press = function(_tp) {
        return BATTLE_MENU.INV_SELECTION
    }
    
    __determine_sprite()
}
function enc_button_item() : enc_button() constructor {
    name = "item"
    press = function(_tp) {
        return BATTLE_MENU.INV_SELECTION
    }
    
    __determine_sprite()
}
function enc_button_spare() : enc_button() constructor {
    name = "spare"
    press = function(_tp) {
        return BATTLE_MENU.ENEMY_SELECTION
    }
    
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