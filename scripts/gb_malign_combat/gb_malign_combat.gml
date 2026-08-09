function gb_enemy_custodian() : enemy() constructor{
	name = "Custodian"
	obj = o_gb_actor_e_custodian
	turn_object = o_gb_turn_custodian
	
	//stats
	hp =		3000
	max_hp =	3000
	attack =	6
	defense =	6
    
    can_spare = false
    mercy_add_pity_percent = 0
	no_mercy_text = "* But, it was not something that can understand MERCY."
    
    // sprites
    s_idle = spr_gb_e_custodian
    s_hurt = spr_gb_e_custodian_hurt
    s_spare = s_idle
	
	//acts
	acts = [
		{
			name: "Check",
			party: [],
			desc: "Useless analysis",
			exec: function() {
				encounter_scene_dialogue("* CUSTODIAN - Floats with a weightless unnerving grace. {col(c_teal)}This should not be on the station!{col(w)}")
			}
		},
	]
    
	//text
	dialogue = function(slot){
	}
}
function gb_enemy_lodestar() : enemy() constructor{
	name = "Lodestar"
	obj = o_gb_actor_e_lodestar
	turn_object = o_gb_turn_lodestar
	
	// stats
	hp =		3000
	max_hp =	3000
	attack =	12
	defense =	3
    
    can_spare = false
    mercy_add_pity_percent = 0
	no_mercy_text = "* But, it was not something that can understand MERCY."
	
    // sprites
    s_idle = spr_gb_e_lodestar
    s_hurt = spr_gb_e_lodestar_hurt
    s_spare = s_idle
    
	// acts
	acts = [
		{
			name: "Check",
			party: [],
			desc: "Useless analysis",
			exec: function() {
				encounter_scene_dialogue("* LODESTAR - A searing light glimmers within. {col(c_teal)}This should not be on the station!{col(w)}")
			}
		},
	]
    
	// text
	dialogue = function(slot){
	}
}