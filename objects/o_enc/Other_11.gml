/// @description reset all variables

turn_flavor = undefined
flavor_seen = false
exec_init = false
dialogue_init = false
pre_turn_init = false
turn_init = false
pre_dialogue_init = false
post_turn_init = false
win_init = false
win_screen_init = false

party_state = array_create(array_length(global.party_names), PARTY_STATE.IDLE)
party_button_selection = array_create(array_length(global.party_names), 0)
party_enemy_selection = array_create(array_length(global.party_names), 0)
party_act_selection = array_create(array_length(global.party_names), 0)
party_item_selection = array_create(array_length(global.party_names), 0)
party_spell_selection = array_create(array_length(global.party_names), 0)
party_ally_selection = array_create(array_length(global.party_names), 0)

party_busy_internal = []
party_selection = 0

action_queue = []
items_using = []

battle_menu = BATTLE_MENU.BUTTON_SELECTION