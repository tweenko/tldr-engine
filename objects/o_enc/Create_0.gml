{ // set up the colors we use for the ui
	bcolor = merge_color(c_purple, c_black, 0.7)
	bcolor = merge_color(bcolor, c_dkgray, 0.5)
}
{ // generic (misc) 
	buffer = 0
    waiting = false // the waiting variable for YOU
    waiting_internal = false // the waiting variable for ME!! me onLY!!!!!!! nGHHHHH im evil
    surf = -1
    
    tp = 0
    tp_constrict = false // darkness constriction
    tp_glow_alpha = 0
    tp_defend = 16
    
    save_follow = array_create_ext(array_length(global.party_names), function(index) {
        return party_get_inst(global.party_names[index]).follow
    })
    save_pos = array_create_ext(array_length(global.party_names), function(index) {
        return [
            party_get_inst(global.party_names[index]).x,
            party_get_inst(global.party_names[index]).y
        ]
    })
    
    turn_timer = 0
    turn_objects = []
    turn_count = 0
    turn_flavor = undefined
    
    // initializers
    flavor_seen = false
    exec_init = false
    dialogue_init = false
    pre_turn_init = false
    turn_init = false
    pre_dialogue_init = false
    post_turn_init = false
    win_screen_init = false
    win_init = false
    party_menu_init = false
    encounter_init = false
    
    // win stuff
    earned_money = 0
    win_dialogue_show = true
    win_message = ""
    win_hide_ui = false
    
    items_using = []
}
{ // ui
    ui_main_lerp = 0
    ui_party_sticks = [0, -3, -6]
    ui_hp_danger_zone = 30
    ui_menu_state = 0
    
    battle_menu = BATTLE_MENU.BUTTON_SELECTION
    
    battle_menu_enemy_proceed = function() {}
    battle_menu_enemy_cancel = function() {}
    
    battle_menu_inv_proceed = function(item_struct) {}
    battle_menu_inv_cancel = function() {}
    battle_menu_inv_list = []
    battle_menu_inv_var_name = ""
    battle_menu_inv_page_var_name = ""
    battle_menu_inv_var_operate = function(_delta, _abs = false) {
        if _abs     party_act_selection_selection[party_selection] = _delta
        else        party_act_selection[party_selection] += _delta
    }
    
    battle_menu_party_proceed = function() {}
    battle_menu_party_cancel = function() {}
}
{ // party
    party_ui_lerp = array_create(array_length(global.party_names), 0)
    party_ui_button_surf = array_create(array_length(global.party_names), -1)
    party_state = array_create(array_length(global.party_names), PARTY_STATE.IDLE)
    party_hurt_timer = array_create(array_length(global.party_names), 0)
    party_buttons = array_create_ext(array_length(global.party_names), function(index) {
        var buttons = [
            new enc_button_fight(),
            undefined, // determined to be spell or act later
            new enc_button_item(),
            new enc_button_spare(),
            new enc_button_defend(),
        ]
        
        if is_undefined(buttons[1]) {
            if item_spell_get_exists(item_s_act, global.party_names[index])
                buttons[1] = new enc_button_act()
            else 
                buttons[1] = new enc_button_power()
        }
        
        return buttons
    })
    party_button_selection = array_create(array_length(global.party_names), 0)
    party_enemy_selection = array_create(array_length(global.party_names), 0)
    party_ally_selection = array_create(array_length(global.party_names), 0)
    party_act_selection = array_create(array_length(global.party_names), 0)
    party_act_page = array_create(array_length(global.party_names), 0)
    party_item_selection = array_create(array_length(global.party_names), 0)
    party_item_page = array_create(array_length(global.party_names), 0)
    party_spell_selection = array_create(array_length(global.party_names), 0)
    party_spell_page = array_create(array_length(global.party_names), 0)
    
    party_selection = 0
    party_busy_internal = []
    party_busy = []
}
{ // instances
    inst_tp_bar = instance_create(o_enc_tp_bar)
    inst_tp_bar.caller = id
    animate(-80, 0, 10, anime_curve.circ_out, inst_tp_bar, "x_offset")
    
    inst_flavor = noone
    inst_dialogues = []
}

encounter_data = {} // the information about the encounter: enemies, music, text and such

action_queue = []
action_order = [
    enc_action_act,
    enc_action_item,
    enc_action_power,
    enc_action_spare,
    enc_action_fight,
    enc_action_defend,
]
for (var i = 0; i < array_length(action_order); i ++) { // convert to script names
    action_order[i] = script_get_name(action_order[i])
}

battle_state = BATTLE_STATE.MENU
battle_state_prev = BATTLE_STATE.MENU
battle_state_order = [
    BATTLE_STATE.MENU,
    BATTLE_STATE.EXEC,
    BATTLE_STATE.DIALOGUE,
    BATTLE_STATE.TURN,
    BATTLE_STATE.POST_TURN,
]

win_condition = function() { // if this is true, the battle will end
    for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
        if enc_enemy_isfighting(i)
            return false
    }
    return true
}

__button_highlight = function(button, party_name) {
	if button.name == "power" { // pacify & sleepmist
		var __tgt_spell = undefined
		var __can_spellspare = false
		
		for (var k = 0; k < array_length(party_getdata(party_name, "spells")); ++k) {
			if party_getdata(party_name, "spells")[k].is_mercyspell {
				__tgt_spell = party_getdata(party_name, "spells")[k]
				__spellowner = party_getname(party_name)
				
				break
			}
		}
		
		// check whether we can pacify the enemy
		for (var m = 0; m < array_length(encounter_data.enemies); ++m) {
			if !enc_enemy_isfighting(m) 
				continue
			
			var _enemy = encounter_data.enemies[m]
			if _enemy.tired {
				if is_struct(__tgt_spell) && tp >= __tgt_spell.tp_cost { // if mercyspell exists
					__can_spellspare = true
				}
			}
		}
		
		return __can_spellspare
	}
	else if button.name == "spare" { // spare
		var __can_spare = false
		
		// check whether we can spare the enemy
		for (var m = 0; m < array_length(encounter_data.enemies); ++m) {
			if !enc_enemy_isfighting(m) 
				continue
			
			var _enemy = encounter_data.enemies[m]
			if _enemy.mercy >= 100 {
				__can_spare = true
			}
		}
		
		return __can_spare
	}
	
	return false
}
__state_to_icon = function(state) {
    switch state {
        default: return -1
        case PARTY_STATE.FIGHT:      return 0
        case PARTY_STATE.ACT:        return 1
        case PARTY_STATE.ITEM:       return 2
        case PARTY_STATE.SPARE:      return 3
        case PARTY_STATE.DEFEND:     return 4
        case PARTY_STATE.POWER:      return 5
    }
}
__battle_state_advance = function(state = battle_state) {
    var cur_state = array_get_index(battle_state_order, state)
    var next_state = (cur_state + array_length(battle_state_order) + 1) % array_length(battle_state_order)
    
    battle_state = battle_state_order[next_state]
    if win_condition()
        battle_state = BATTLE_STATE.WIN
}

__enemy_highlight = function(enemy_index) {
    for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
        if !enc_enemy_isfighting(i)
            continue
        if !instance_exists(encounter_data.enemies[i].actor_id)
            continue
        
        if enemy_index == i
            encounter_data.enemies[i].actor_id.flashing = true
        else
            encounter_data.enemies[i].actor_id.flashing = false
    }
}
__enemy_highlight_reset = function() {
    for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
        if !enc_enemy_isfighting(i)
            continue
        if !instance_exists(encounter_data.enemies[i].actor_id)
            continue
        
        encounter_data.enemies[i].actor_id.flashing = false
    }
}
__ally_highlight = function(ally_index) {
    for (var i = 0; i < array_length(global.party_names); ++i) {
        var inst = party_get_inst(global.party_names[i])
        if !party_isup(global.party_names[i])
            continue
        if !instance_exists(inst)
            continue
        
        if ally_index == i
            inst.flashing = true
        else
            inst.flashing = false
    }
}
__ally_highlight_reset = function() {
    for (var i = 0; i < array_length(global.party_names); ++i) {
        var inst = party_get_inst(global.party_names[i])
        if !party_isup(global.party_names[i])
            continue
        if !instance_exists(inst)
            continue
        
        inst.flashing = false
    }
}

__order_action_queue = function(_action_queue = action_queue) {
    var output = array_filter(_action_queue, function(element, index) { // remove defend
        if is_instanceof(element, enc_action_defend)
            return false
        return true
    })
    
    array_sort_ext(output, function(current, next) {
        var cur_order = array_get_index(action_order, instanceof(current))
        var next_order = array_get_index(action_order, instanceof(next))
        var party_order = party_get_index(current.acting_member)
        var next_party_order = party_get_index(next.acting_member)
        
        show_debug_message($"action_sort 1: {instanceof(current)}, order value: {cur_order}")
        show_debug_message($"action_sort 1: {instanceof(next)}, order value: {next_order}, score: {next_order - cur_order}")
        
        return next_order - cur_order + party_order - next_party_order
    })
    
    return output
}
__check_waiting = function() {
    return waiting || waiting_internal
}

__act_sort = function(enemy_index) {
	var acts = encounter_data.enemies[enemy_index].acts
	for (var i = 0; i < array_length(acts); ++i) {
		if is_array(acts[i].party) && array_length(acts[i].party) > 0 {
			var contains = true
			for (var j = 0; j < array_length(acts[i].party); ++j) {
			    contains = array_contains(global.party_names, acts[i].party[j])
				if !contains 
					break
			}
			if !contains 
				array_delete(acts, i, 1)
		}
	}
	
	return acts
}
__item_sort = function(at_point = array_length(items_using)) {
	var __items = variable_clone(item_get_array(0))
	for (var i = array_length(__items)-1; i >= 0; i --) {
        if array_contains(items_using, i)
            array_delete(__items, i, 1)
    }
	return __items
}
__spell_sort = function(party_name) {
    var spells = []
    spells = variable_clone(party_getdata(party_name, "spells"))
    for (var i = 0; i < array_length(struct_get(encounter_data.party_actions, party_name)); ++i) {
        array_insert(spells, i, struct_get(encounter_data.party_actions, party_name)[i])
    }
    return spells
}

/// @description calls events for all enemies and the encounter struct
/// @arg {string} event_name starts with "ev_" (e.g. "ev_pre_dialogue")
__call_enc_event = function(event_name) {
    for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
        if enc_enemy_isfighting(i) {
            // call the pre-dialogue event for the enemies
            if is_callable(variable_struct_get(encounter_data.enemies[i], event_name))
                variable_struct_get(encounter_data.enemies[i], event_name)()
        }
    }
    if is_callable(variable_struct_get(encounter_data, event_name))
        variable_struct_get(encounter_data, event_name)()
}

enum BATTLE_MENU {
    BUTTON_SELECTION,
    ENEMY_SELECTION,
    INV_SELECTION,
    PARTY_SELECTION,
}
enum BATTLE_STATE {
    MENU,
    EXEC,
    DIALOGUE,
    TURN,
    POST_TURN,
    WIN
}
enum PARTY_STATE {
    IDLE, 
    FIGHT,
    ACT,
    POWER,
    ITEM,
    SPARE,
    DEFEND
}