function ch5_enemy_knight() : enemy() constructor {
    name = "Knight"
	obj = o_ch5_actor_e_knight
	
	// stats
	hp =		1240
	max_hp =	1240
	attack =	14
	defense =	3
	status_effect = ""
    freezable = false
    
    can_spare = false
	
	// acts
	acts = [
		{
			name: loc("enc_act_check"),
			desc: "Useless analysis",
			party: [],
			exec: function() {
				encounter_scene_dialogue(loc("enemy_virovirokun_act_check"))
			}
		},
    ]
}