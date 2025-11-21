function ex_enemy_shadowguy() : enemy() constructor{
	name = "Shadowguy"
	obj = o_ex_actor_e_sguy
	turn_object = o_ex_turn_sguy
	
	//stats
	hp =		240
	max_hp =	240
	attack =	5
	defense =	0
	
	shoot_sprites = {
		kris: spr_ex_kris_costume,
		susie: spr_ex_susie_costume,
		ralsei: spr_ex_ralsei_costume,
	}
	
	//acts
	acts = [
		{
			name: "Check",
			party: [],
			desc: -1,
			exec: function() {
				encounter_scene_dialogue("* SHADOWGUY - ATK 10 DEF 1{s(10)}{br}{resetx}* Battling's just a side gig. Playing on stage is the dream!")
			}
		},
		{
			name: "ShootX",
			party: -1,
			desc: -1,
			exec: function(slot, actorid) {
				var me = o_enc.encounter_data.enemies[slot]
				
				cutscene_create()
				cutscene_set_variable(o_enc, "waiting", true)
				
				cutscene_sleep(10)
				
				var dia = "{can_skip(false)}* Aim with " + input_binding_intext([INPUT_VERB.LEFT, INPUT_VERB.RIGHT])
				dia += " and " + input_binding_intext([INPUT_VERB.UP, INPUT_VERB.DOWN]) + "! "
				dia += "{br}{resetx}{s(10)}* Fire with " + input_binding_intext(INPUT_VERB.SPECIAL) + "!{stop}"
				
				cutscene_dialogue(dia, "", false)
				
				cutscene_instance_create(o_ex_enc_m_shooter, me.actor_id.x, guipos_y()+100,, {
					shoot_sprites: me.shoot_sprites
				})
				cutscene_wait_until(function(){
					return !instance_exists(o_ex_enc_m_shooter)
				})
				
				cutscene_func(function(){instance_destroy(o_ui_dialogue)})
				cutscene_sleep(30)
				
				cutscene_set_variable(o_enc, "waiting", false)
				cutscene_play()
			}
		}
	]
	
	// recruit
	recruit = new ex_enemy_recruit_shadowguy()
    
	// text
	dialogue = function(slot){}
}

function ex_enemy_spawnling() : enemy() constructor{
	name = "Spawnling"
	obj = {
        obj: o_ex_actor_e_spawnling,
        var_struct: {
            s_hurt: spr_ex_e_spawnling_hurt,
            s_spared: spr_ex_e_spawnling,
        }
    }
	turn_object = o_turn_default_dark
	
	//stats
	hp =		5000
	max_hp =	5000
	attack =	30
	defense =	6
	
	//acts
	acts = [
		{
			name: "Check",
			party: [],
			desc: -1,
			exec: function() {
				encounter_scene_dialogue("* SPAWNLING - Common TITAN SPAWN. Use {col(c_orange)}FOCUS{col(w)} to burn its shell.")
			}
		},
	]
    
	//text
	dialogue = function(slot){
	}
}
function ex_enemy_dentos() : enemy() constructor{
	name = "Dentos"
	obj = {
        obj: o_ex_actor_e_dentos,
        var_struct: {
            s_hurt: spr_ex_e_dentos_hurt,
            s_spared: spr_ex_e_dentos,
        }
    }
	turn_object = o_ex_turn_dentos
	
	//stats
	hp =		5000
	max_hp =	5000
	attack =	30
	defense =	6
	
	//acts
	acts = [
		{
			name: "Check",
			party: [],
			desc: -1,
			exec: function() {
				encounter_scene_dialogue("* DENTOS - Beware of its sharp teeth. Use {col(c_orange)}FOCUS{col(w)} to burn its shell.")
			}
		},
	]
    
	//text
	dialogue = function(slot){
	}
}