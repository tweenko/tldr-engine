function enc_action(_party_names) constructor {
    party_names = _party_names // can be array/string
    target = -1
    party_state = PARTY_STATE.IDLE
    
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
    }
}

function enc_action_fight(_party_names, _enemy_target) : enc_action(_party_names) constructor {
    target = _enemy_target
    party_state = PARTY_STATE.FIGHT
}
function enc_action_act(_party_names, _enemy_target, _act) : enc_action(_party_names) constructor {
    target = _enemy_target
    target_act = _act
    party_state = PARTY_STATE.ACT
}
function enc_action_power(_party_names, _target, _spell) : enc_action(_party_names) constructor {
    target = _target
    target_spell = _spell
    party_state = PARTY_STATE.POWER
}
function enc_action_item(_party_names, _target, _target_type, _item) : enc_action(_party_names) constructor {
    target = _target
    target_type = _target_type
    target_item = _item
    
    party_state = PARTY_STATE.ITEM
}
function enc_action_spare(_party_names, _enemy_target) : enc_action(_party_names) constructor {
    target = _enemy_target
    party_state = PARTY_STATE.SPARE
}
function enc_action_defend(_party_names) : enc_action(_party_names) constructor {
    party_state = PARTY_STATE.DEFEND
}