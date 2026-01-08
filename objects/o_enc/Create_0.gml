{ // set up the colors we use for the ui
	bcolor = merge_color(c_purple, c_black, 0.7)
	bcolor = merge_color(bcolor, c_dkgray, 0.5)
}
{ // generic (misc) 
	buffer = 0
    waiting = false // the waiting variable for EVERYTHING
    surf = -1
}
{ // ui
    ui_main_lerp = 0
    ui_party_sticks = [0, -3, -6]
    ui_hp_danger_zone = 30
    ui_menu_state = 0
}
{ // party
    party_ui_lerp = array_create(array_length(global.party_names), 0)
    party_ui_button_surf = array_create(array_length(global.party_names), -1)
    party_state = array_create(array_length(global.party_names), PARTY_STATE.IDLE)
    party_hurt_timer = array_create(array_length(global.party_names), 0)
    party_buttons = array_create_ext(array_length(global.party_names), function(index) {
        var order = [PARTY_BUTTONS.FIGHT, PARTY_BUTTONS.POWER, PARTY_BUTTONS.ITEM, PARTY_BUTTONS.SPARE, PARTY_BUTTONS.DEFEND]
        if item_spell_get_exists(item_s_act, global.party_names[index])
            order[1] = PARTY_BUTTONS.ACT
        return order
    })
    party_button_selection = array_create(array_length(global.party_names), 0)
}
{ // instances
    inst_tp_bar = instance_create(o_enc_tp_bar)
    inst_tp_bar.caller = id
    animate(-80, 0, 10, anime_curve.circ_out, inst_tp_bar, "x_offset")
}

action_queue = []

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

encounter_data = {} // the information about the encounter: enemies, music, text and such

tp = 0
tp_constrict = false // darkness constriction
tp_glow_alpha = 0

party_selection = 0
party_busy = []

__button_highlight = function(button, party_name) {
	if button == PARTY_BUTTONS.POWER { // pacify
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
	else if button == PARTY_BUTTONS.SPARE { // spare
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
__battle_state_advance = function(state = battle_state) {
    var cur_state = array_get_index(battle_state_order, state)
    var next_state = (cur_state + array_length(battle_state_order) + 1) % array_length(battle_state_order)
    
    battle_state = battle_state_order[next_state]
}
__button_to_sprite = function(button) {
    var suffix = ""
    switch button {
        case PARTY_BUTTONS.FIGHT: 
            suffix = "fight"
            break
        case PARTY_BUTTONS.ACT: 
            suffix = "act"
            break
        case PARTY_BUTTONS.POWER: 
            suffix = "power"
            break
        case PARTY_BUTTONS.ITEM: 
            suffix = "item"
            break
        case PARTY_BUTTONS.SPARE: 
            suffix = "spare"
            break
        case PARTY_BUTTONS.DEFEND: 
            suffix = "defend"
            break
    }
    return asset_get_index(string(loc("enc_ui_spr_buttons"), suffix))
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
enum PARTY_BUTTONS {
    FIGHT,
    ACT,
    POWER,
    ITEM,
    SPARE,
    DEFEND
}