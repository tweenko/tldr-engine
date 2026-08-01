function ex_enemy_custodian() : enemy() constructor{
	name = "custodian"
	obj = o_ex_actor_e_spawnling
	turn_object = o_turn_default_dark
	
	//stats
	hp =		1500
	max_hp =	1500
	attack =	9
	defense =	3
    
    can_spare = false
    mercy_add_pity_percent = 0
	no_mercy_text = "* But, it was not something that can understand MERCY."
    
    // sprites
    s_idle = spr_ex_e_custodian
    s_hurt = spr_ex_e_custodian_hurt
    s_spare = s_idle
	
	//acts
	acts = [
		{
			name: "Check",
			party: [],
			desc: "Useless analysis",
			exec: function() {
				encounter_scene_dialogue("* CUSTODIAN - Floats with a weightless, unnerving grace. Use {col(c_orange)}FOCUS{col(w)} to burn its shell.")
			}
		},
	]
    
	//text
	dialogue = function(slot){
	}
}
function ex_enemy_lodestar() : enemy() constructor{
	name = "Lodestar"
	obj = o_ex_actor_e_lodestar
	turn_object = o_ex_turn_lodestar
	
	// stats
	hp =		1500
	max_hp =	1500
	attack =	9
	defense =	3
    
    can_spare = false
    mercy_add_pity_percent = 0
	no_mercy_text = "* But, it was not something that can understand MERCY."
	
    // sprites
    s_idle = spr_ex_e_lodestar
    s_hurt = spr_ex_e_lodestar_hurt
    s_spare = s_idle
    
	// acts
	acts = [
		{
			name: "Check",
			party: [],
			desc: "Useless analysis",
			exec: function() {
				encounter_scene_dialogue("* LODESTAR - A searing light glimmers within. Use {col(c_orange)}FOCUS{col(w)} to burn its casing.")
			}
		},
	]
    
	// text
	dialogue = function(slot){
	}
}