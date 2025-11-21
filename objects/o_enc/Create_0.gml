{ // set up the colors we use for the ui
	bcolor = merge_color(c_purple, c_black, 0.7)
	bcolor = merge_color(bcolor, c_dkgray, 0.5)
}
{ // visual variables
	surf = -1 // the main surface
    tp_surf = -1
	roll = 0
	tproll = 0
	
	buttonsurf = array_create(array_length(global.party_names), -1)
	uisticks = [0, -3, -6]
}
{ // generic (misc) 
	buffer = 0
	
	dialogue_init = true
	dialogue_autoskip = false
	
	hideui = false
	wininit = false
    earned_money = 0
    flavor = ""
	
	save_pos = []
    save_follow = []
    
	items_using = []
    
	dialogueinstances = []
	menutext = noone
	mybox = noone
	mysoul = noone
    
    win_message = ""
    
    waiting = false // the waiting variable for EVERYTHING
}

{ // arrays for each party member
	can_act = array_create_ext(
		array_length(global.party_names), 
		function(index) {
			return item_spell_get_exists(item_s_act, global.party_names[index])
		}
	)
	pmlerp = array_create(array_length(global.party_names), 0)
	bt_selection = array_create(array_length(global.party_names), 0)
    pm_hurt = array_create(array_length(global.party_names), 0)
	
	fightselection = array_create(array_length(global.party_names), 0)
	
	actselection = array_create(array_length(global.party_names), 0)
	
	itemselection = array_create(array_length(global.party_names), 0)
	itempage = array_create(array_length(global.party_names), 0)
	itemuserselection = array_create(array_length(global.party_names), 0)
	
	spellpage = array_create(array_length(global.party_names), 0)
	spell_using = array_create(array_length(global.party_names), -1)
	tp_upon_spell = array_create(array_length(global.party_names), -1)
	
	partyactselection = array_create(array_length(global.party_names), 0)
	together_with = array_create(array_length(global.party_names), [])
	
	char_state = array_create(array_length(global.party_names), CHAR_STATE.IDLE)
}

{ // action execution - party turn
	exec_queue = ds_queue_create()
	exec_calculated = false
	exec_current = undefined
    exec_buffer = 0
	waiting = false
	waiting = false
}

{ // attack execution
	fighters = []
	fighterselection = []
}
{ // party actions (aside from s-action and alike)
	bonus_actions = {}
	var names = struct_get_names(global.party)
	for (var i = 0; i < array_length(names); ++i) {
	    struct_set(bonus_actions, names[i], [new item_s_defaultaction(names[i])])
	}
}

{ // enemy's turn
	turn_timer = 0
	turn_objects = []
	turn_targets = [] // determined in-turn
	turn_init = false
	turn_goingback = false
}

selection = 0
state = 0 // how deep we are in the menu
battle_state = "menu"
battle_state_prev = "menu"

encounter_data = {} // the information about the encounter: enemies, music, text and such

tp = 0
tplerp = 0
tplerp2 = 0
tp_constrict = false // darkness constriction
tp_glow_alpha = 0

ignore = [] // the "busy" party members

// methods
__act_sort = function() {
	var acts = encounter_data.enemies[fightselection[selection]].acts
	
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
	var items = array_clone(item_get_array(0))
	var itemsusing = []
	
	array_copy(itemsusing, 0, items_using, 0, at_point)
	
	for (var i = 0; i < array_length(items); ++i) {
	    if array_contains(itemsusing, item_get_name(items[i])){
			array_delete(itemsusing, array_get_index(itemsusing, item_get_name(items[i])), 1)
			array_delete(items, i, 1)
		}
	}
	return items
}
__bt_highlight = function(button_index, party_name) {
	if button_index == 1 { // pacify
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
	else if button_index == 3 { // spare
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
        case CHAR_STATE.FIGHT:      return 0
        case CHAR_STATE.ACT:        return 1
        case CHAR_STATE.ITEM:       return 2
        case CHAR_STATE.SPARE:      return 3
        case CHAR_STATE.DEFEND:     return 4
        case CHAR_STATE.POWER:      return 5
    }
}

enum CHAR_STATE {
    IDLE, 
    FIGHT,
    ACT,
    POWER,
    ITEM,
    SPARE,
    DEFEND
}