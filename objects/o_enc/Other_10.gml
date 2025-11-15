/// @description reset all the main variables

{ // generic (misc) 
	dialogue_init = true
	dialogue_autoskip = false
	
	hideui = false
	
	items_using = []
	
	dialogueinstances = []
	menutext = noone
	mybox = noone
	mysoul = noone
}
{ // arrays for each party member
	pmlerp = array_create(array_length(global.party_names), 0)
	bt_selection = array_create(array_length(global.party_names), 0)
	
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
	waiting = false
	waiting = false
}
{ // attack execution
	fighters = []
	fighterselection = []
}
{ // enemy's turn
	turn_timer = 0
	turn_objects = []
	turn_targets = [] // determined in-turn
	turn_init = false
	turn_goingback = false
}

selection = 0
while !party_isup(global.party_names[selection]) && selection < array_length(global.party_names)-1 {
    selection ++
}

state = 0 // how deep we are in the menu
battle_state = "menu"

ignore = [] // the "busy" party members