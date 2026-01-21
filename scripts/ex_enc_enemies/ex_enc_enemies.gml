function ex_enemy_shadowguy() : enemy() constructor{
	name = "Shadowguy"
	obj = o_ex_actor_e_sguy
	turn_object = o_ex_turn_sguy
	
	//stats
	hp =		240
	max_hp =	240
	attack =	5
	defense =	0
	
    boogie_sprites = {
        kris: spr_ex_kris_boogie
    }
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
			desc: "Useless analysis",
			exec: function() {
				encounter_scene_dialogue("* SHADOWGUY - ATK 10 DEF 1{s(10)}{br}{resetx}* Battling's just a side gig. Playing on stage is the dream!")
			}
		},
        {
			name: "Boogie",
			party: [],
			desc: "Dance, don't get hit!",
            perform_act_anim: false,
            
			exec: function(slot, user, boogie_sprites) {
				var me = o_enc.encounter_data.enemies[slot]
				
				cutscene_create()
				cutscene_set_variable(o_enc, "waiting", true)
				
				cutscene_func(enc_enemy_add_spare, [slot, 5])
                cutscene_func(function(user, boogie_sprites) {
                    if struct_exists(boogie_sprites, user) {
                        var o = party_get_inst(user)
                        
                        o.sprite_index = struct_get(boogie_sprites, user)
                        
                        var inst = afterimage(.03, o)
                        inst.speed = 1
                        inst = afterimage(.04, o)
                        inst.speed = 2
                    
                        var a = animate(.5, 1, 4, anime_curve.linear, o, "flash")
                            a._add(0, 6, anime_curve.linear)
                            a._start()
                    }
                    instance_create(o_ex_enc_m_boogie_controller)
                }, [user, boogie_sprites])
                
				cutscene_dialogue("* " + party_getname(user) + " boogies past bullets!{br}{resetx}* SHADOWGUY gains mercy until you get hit!")
                cutscene_set_partysprite(user, "idle")
				
				cutscene_set_variable(o_enc, "waiting", false)
				cutscene_play()
			},
            exec_args: [boogie_sprites] 
		},
		{
			name: "Sharpshoot",
			party: -1,
			desc: "Light\n'em up",
            perform_act_anim: false,
			exec: function(slot, user) {
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
                cutscene_func(function(slot) {
                    for (var i = 0; i < array_length(global.party_names); ++i) {
                        enc_party_set_battle_sprite(global.party_names[i], "idle")
                    }
                }, slot)
				
				cutscene_set_variable(o_enc, "waiting", false)
				cutscene_play()
			}
		},
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
    
    can_spare = false
    mercy_add_pity_percent = 0
	
	//acts
	acts = [
		{
			name: "Check",
			party: [],
			desc: "Useless analysis",
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
    
    can_spare = false
    mercy_add_pity_percent = 0
	
	//acts
	acts = [
		{
			name: "Check",
			party: [],
			desc: "Useless analysis",
			exec: function() {
				encounter_scene_dialogue("* DENTOS - Beware of its sharp teeth. Use {col(c_orange)}FOCUS{col(w)} to burn its shell.")
			}
		},
	]
    
	//text
	dialogue = function(slot){
	}
}