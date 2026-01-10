{ // set up the colors we use for the ui
	bcolor = merge_color(c_purple, c_black, 0.7)
	bcolor = merge_color(bcolor, c_dkgray, 0.5)
}
{ // generic (misc) 
	buffer = 0
    waiting = false // the waiting variable for EVERYTHING
    surf = -1
    flavor_seen = false
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
}
{ // instances
    inst_tp_bar = instance_create(o_enc_tp_bar)
    inst_tp_bar.caller = id
    animate(-80, 0, 10, anime_curve.circ_out, inst_tp_bar, "x_offset")
    
    inst_flavor = noone
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

battle_menu = BATTLE_MENU.BUTTON_SELECTION
battle_menu_init = false

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
party_busy_internal = []
party_busy = []

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

enum BATTLE_MENU {
    BUTTON_SELECTION,
    ENEMY_SELECTION,
    ACT_SELECTION,
    INV_SELECTION,
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


party_busy = ["susie"]
party_state[1] = PARTY_STATE.FIGHT