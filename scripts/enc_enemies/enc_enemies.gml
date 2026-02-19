function enemy() constructor {
	// base info
	name = "Test"
	obj = o_actor_e
	
	// stats
	hp =		170
	max_hp =	170
	attack =	0
	defense =	0
	status_effect = ""
    carrying_money = 0
	
	mercy =	0
    mercy_add_pity_percent = 20
    can_spare = true
    
	tired =	false
	
	// acts
	acts = [
		{
			name: loc("enc_act_check"),
			desc: "Useless analysis",
			party: [],
            tp_cost: 0, // optional, 0 by default
            
            enabled: true, // optional, true by default. can also be callable
            perform_act_anim: true, // optional, true by default
            return_to_idle_sprites: true, // optional, true by default
            
			exec: function(enemy_slot, user_index){
				encounter_scene_dialogue("* Empty CHECK text.")
			},
            exec_args: []
            
		},
	]
	acts_special = {}
	acts_special_desc = loc("enc_ui_label_standard")
	
	// text
	dialogue =				"Test" // can be a function (can accept slot argument as arg0)
	dia_bubble_off_x =		0
	dia_bubble_off_y =		0
    dia_bubble_off_type =	BUBBLE_RELATIVE.TO_DEFAULT_POS
	dia_bubble_sprites =	[spr_ui_enc_dialogue_box, spr_ui_enc_dialogue_spike]
	
	turn_object = o_turn_default
	
    // misc
    freezable = false
    defeat_marker = 0 // marker id
    run_away = true // if set to false, if dealt fatal damage the enemy will die
    
    // sprites
    s_idle = spr_e_virovirokun_idle
    s_spare = spr_e_virovirokun_spare
    s_hurt = spr_e_virovirokun_hurt
    
	// misc (in-fight events)
    ev_pre_dialogue =   -1
	ev_dialogue =	    -1
	ev_turn =	  	    -1
    ev_turn_start =     -1
	ev_post_turn =	    -1
    ev_win =            -1
	
	//recruit
	recruit = new enemy_recruit()
	
	//system
	actor_id =	-1
	slot =		-1
    
    // methods
    __defeat = method(self, function(way_of_defeat = undefined) {
        if instance_exists(o_enc) {
            if !is_undefined(way_of_defeat)
                o_enc.encounter_data.enemies[slot] = way_of_defeat
            o_enc.earned_money += carrying_money // add money
        }
    })
    
    __run_defeat = method(self, function() {
        actor_id.run_away = true
        audio_play(snd_defeatrun)
        
        __defeat("ran away")
        if !recruit_islost(self) {
            instance_create(o_text_hpchange, actor_id.x, actor_id.s_get_middle_y(), actor_id.depth - 100, {
                draw: "lost",
                mode: TEXT_HPCHANGE_MODE.SCALE,
            })
            recruit_lose(self)
        }
    })
    __fatal_defeat = method(self, function() {
        with actor_id
            instance_create(o_eff_fatal_damage, x, y, depth, {
                sprite_index: other.s_hurt,
                image_xscale: image_xscale,
                image_yscale: image_yscale,
                image_index: image_index,
                image_speed: 0,
                shake: 6,
            })
        instance_destroy(actor_id)
        
        __defeat("fatal")
        if !recruit_islost(self)
            recruit_lose(self)
    })
    __freeze_defeat = method(self, function() {
        animate(0, 1, 20, "linear", actor_id, "freeze")
        
        with actor_id
            instance_create(o_text_hpchange, x, s_get_middle_y(), depth - 100, {
                draw: "frozen",
                mode: TEXT_HPCHANGE_MODE.SCALE,
            })
        audio_play(snd_petrify)
        
        if !recruit_islost(self)
            recruit_lose(self)
        __defeat("frozen")
    })
}

function enemy_virovirokun() : enemy() constructor{
	name = loc("enemy_virovirokun_name")
	obj = o_actor_e_virovirokun
	
	// stats
	hp =		240
	max_hp =	240
	attack =	8
	defense =	0
	status_effect = ""
    freezable = true
    carrying_money = 84
    
    mercy = 0
	
    // sprites
    s_idle = spr_e_virovirokun_idle
    s_spare = spr_e_virovirokun_spare
    s_hurt = spr_e_virovirokun_hurt
    
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
		{
			name: loc("enemy_virovirokun_act_takecare"),
			party: [],
			desc: -1,
            perform_act_anim: false,
			exec: function(slot, user) {
				cutscene_create()
				cutscene_set_variable(o_enc, "waiting", true)
				
				cutscene_func(enc_enemy_add_spare, [slot, 100])
				cutscene_func(function(user) {
					var o = party_get_inst(user)
					o.sprite_index = asset_get_index($"spr_b{user}_nurse")
					
					var inst = afterimage(.03,o)
					inst.speed = 1
					inst = afterimage(.04, o)
					inst.speed = 2
                    
                    var a = animate(.5, 1, 4, anime_curve.linear, o, "flash")
                        a._add(0, 6, anime_curve.linear)
                        a._start()
				}, user)
				
				cutscene_dialogue(loc("enemy_virovirokun_act_takecare_msg"))
                
				cutscene_set_variable(o_enc, "waiting", false)
				cutscene_play()
			}
		},
		{
			name: loc("enemy_virovirokun_act_takecarex"),
			party: -1,
			desc: -1,
            perform_act_anim: false,
			exec: function(slot, user) {
				cutscene_create()
				cutscene_set_variable(o_enc, "waiting", true)
				
				cutscene_func(function(user) {
					for (var i = 0; i < array_length(global.party_names); ++i) {
					    var name = global.party_names[i]
						var o = party_get_inst(name)
						o.sprite_index = asset_get_index($"spr_b{name}_nurse")
						o.image_speed = 0
						o.image_index = irandom(sprite_get_number(o.sprite_index)-1)
						
						var inst = afterimage(.03, o)
						inst.speed = 1
						inst = afterimage(.04, o)
						inst.speed = 2
						
                        var a = animate(.5, 1, 4, anime_curve.linear, o, "flash")
                            a._add(0, 6, anime_curve.linear)
                            a._start()
					}
					for (var i = 0; i < array_length(o_enc.encounter_data.enemies); ++i) {
						if enc_enemy_isfighting(i) {
							if is_instanceof(o_enc.encounter_data.enemies[i], enemy_virovirokun)
								enc_enemy_add_spare(i, 100)
							else 
								enc_enemy_add_spare(i, 50)
						}
					}
				}, user)
				cutscene_dialogue(loc("enemy_virovirokun_act_takecarex_msg"))
				cutscene_set_variable(o_enc, "waiting", false)
				cutscene_play()
			}
		},
    ]
	acts_special = {
		susie: {
			exec: function(enemy_slot){
				enc_enemy_add_spare(enemy_slot, 50)
				cutscene_dialogue(loc("enemy_virovirokun_act_susie"))
			},
		},
		ralsei: {
			exec: function(enemy_slot){
				enc_enemy_add_spare(enemy_slot, 50)
				cutscene_dialogue(loc("enemy_virovirokun_act_ralsei"))
			},
		},
		noelle: {
			exec: function(enemy_slot) {
				enc_enemy_add_spare(enemy_slot, 50)
				cutscene_dialogue(loc("enemy_virovirokun_act_noelle"))
			},
		},
	}
    
	// recruit
    recruit = new enemy_recruit_virovirokun()
		
	// text
	dialogue = function(slot) {
		if self.mercy >= 100 
			return array_shuffle(loc("enemy_virovirokun_mercy"))[0]
		return array_shuffle(loc("enemy_virovirokun_dialogue"))[0]
	}
}
function enemy_killercar() : enemy() constructor{
	name = "Killer Car"
	
	obj = o_actor_e_killercar
	tired = true
	defense = 0
    turn_object = o_ex_turn_complex_box
    carrying_money = 1
    
    hp = 600
    max_hp = 600
    
    can_spare = false
    mercy_add_pity_percent = 0
	
    // sprites
    s_idle = spr_e_killercar
    s_spare = spr_e_killercar
    s_hurt = spr_e_killercar_hurt
    
	acts = [
		{
			name: "Check",
			desc: "Useless analysis",
			party: [],
			desc: -1,
			exec: function() {
				encounter_scene_dialogue("* Killer Car - As dangerous as it gets. Be prepared for torment.")
			}
		},
		{
			name: "Susie's Idea",
			party: ["susie"],
			desc: "Fatal",
            tp_cost: 32,
			exec: function(slot, user) {
				cutscene_create()
				cutscene_set_variable(o_enc, "waiting", true)
				
				cutscene_dialogue([
					"{char(susie, 21)}* I have an idea.",
				])
				cutscene_set_partysprite("susie", "spell")
				cutscene_sleep(30)
				cutscene_func(enc_hurt_enemy, [slot, 100 * party_getdata("susie", "attack") * party_getdata("susie", "magic"), user, snd_damage, true])
				cutscene_sleep(30)
				
                cutscene_set_partysprite("susie", "idle")
				cutscene_set_variable(o_enc, "waiting", false)
				cutscene_play()
			}
		},
        {
            name: "Tell Story",
            party: ["ralsei"],
            desc: "Induce TIRED",
            exec: function(slot, user) {
                cutscene_create()
                cutscene_set_variable(o_enc, "waiting", true)
                
                cutscene_dialogue("{auto_breaks(false)}* You and Ralsei told the dummy{br}bedtime story.{br}{resetx}* The enemies became {col(`tired_aqua`)}TIRED{col(w)}...",, false)
                cutscene_sleep(16)
                
                cutscene_audio_play(snd_spellcast)
                for (var i = 0; i < array_length(o_enc.encounter_data.enemies); i ++) {
                    if !enc_enemy_isfighting(i)
                        continue
                    cutscene_func(function(index) {
                        var __e_obj = o_enc.encounter_data.enemies[index].actor_id
                        
                        enc_enemy_set_tired(index, true)
                        instance_create(o_text_hpchange, __e_obj.x, __e_obj.s_get_middle_y(), __e_obj.depth - 100, {draw: "tired"})
                    }, [i])
                }
                cutscene_sleep(20)
                
                cutscene_wait_until(function() {
                    return !instance_exists(o_ui_dialogue)
                })
                
                cutscene_set_variable(o_enc, "waiting", false)
                cutscene_play()
            }
        }
	]
	
	act_desc = array_create(array_length(acts), -1)
	act_desc[1] = "Kill Em with Ralsei"
    
    my_inst_almond = noone
    ev_post_turn = method(self, function() {
        if hp > max_hp/1.5
            return false
        
        o_enc.waiting = true
        
        cutscene_create()
        cutscene_sleep(10)
        cutscene_dialogue([
            "* Killer Car felt like it needed to aura-farm a bit.",
            "{can_skip(false)}* Killer Car practiced self-care!{s(30)}"
        ],, false)
        cutscene_wait_dialogue_boxes(1)
        
        cutscene_func(method(self, function(__enemy) {
            var inst = instance_create(o_dummy, __enemy.x - 50, __enemy.s_get_middle_y(), __enemy.depth - 50, {
                sprite_index: spr_ex_almond_milk
            })
            animate(2.5, 1, 10, "linear", inst, "image_xscale")
            animate(2.5, 1, 10, "linear", inst, "image_yscale")
            animate(0, 1, 10, "linear", inst, "image_alpha")
            
            my_inst_almond = inst
        }), [actor_id])
        cutscene_sleep(15)
        
        cutscene_func(method(self, function(__enemy) {
            animate(my_inst_almond.x, __enemy.x, 10, "cubic_in", my_inst_almond, "x")
            animate(1, 0, 10, "cubic_in", my_inst_almond, "image_alpha")
        }), [actor_id])
        cutscene_sleep(10)
        
        cutscene_func(method(self, function(__enemy, callback) {
            instance_destroy(my_inst_almond)
            instance_create(o_eff_healeffect,,,, {
                target: __enemy
            })
            
            callback()
        }), [
                actor_id, 
                method(self, function() {
                    hp += 300
                })
            ]
        )
        cutscene_animate(0, 1, 3, "linear", actor_id, "flash")
        cutscene_sleep(3)
        
        cutscene_audio_play(snd_heal)
        cutscene_func(function(o) {
            instance_create(o_text_hpchange, o.x, o.s_get_middle_y(), o.depth-100, {
				draw: 300, 
				mode: TEXT_HPCHANGE_MODE.PARTY
			})
        }, [actor_id])
        cutscene_animate(1, 0, 10, "linear", actor_id, "flash")
        
        cutscene_wait_dialogue_finish()
        cutscene_set_variable(o_enc, "waiting", false)
        cutscene_play()
    })
    
    recruit = new enemy_recruit_killercar()
}