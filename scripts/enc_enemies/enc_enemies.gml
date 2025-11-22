function enemy() constructor {
	// base info
	name = "Test"
	obj = {
		obj: o_actor_e,
		var_struct: {
			s_hurt: spr_e_virovirokun_hurt,
			s_spared: spr_e_virovirokun_spare,
            carrying_money: 10
		},
	}
	
	// stats
	hp =		170
	max_hp =	170
	attack =	0
	defense =	0
	status_effect = ""
	
	mercy =	0
	tired =	false
    can_spare = true
	
	// acts
	acts = [
		{
			name:	loc("enc_act_check"),
			party:	[],
			desc:	-1,
			exec:	function(enemy_slot, user_index){
				encounter_scene_dialogue("* Empty CHECK text.")
			}
		},
	]
	acts_special = {
	}
	acts_special_desc = loc("enc_ui_label_standard")
	
	// text
	dialogue =				"Test" // can be a function (can accept slot argument as arg0)
	dia_bubble_offset =		[0, 0, 0] // x, y, relative to (1 for enemy and 0 for default box pos)
	dia_bubble_sprites =	[spr_ui_enc_dialogue_box, spr_ui_enc_dialogue_spike]
	
	turn_object = o_turn_default
	
    // misc
    freezable = false
    defeat_marker = 0 // marker id
    
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
    
    mercy = 100
	
	// acts
	acts = [
		{
			name: loc("enc_act_check"),
			party: [],
			desc: -1,
			exec: function() {
				encounter_scene_dialogue(loc("enemy_virovirokun_act_check"))
			}
		},
		{
			name: loc("enemy_virovirokun_act_takecare"),
			party: [],
			desc: -1,
			tp_cost: 0,
			exec: function(slot, user) {
				cutscene_create()
				cutscene_set_variable(o_enc, "waiting", true)
				
				cutscene_func(enc_sparepercent_enemy, [slot, 100])
				cutscene_func(function(user) {
					var name = global.party_names[user]
					var o = party_get_inst(name)
					o.sprite_index = asset_get_index($"spr_b{name}_nurse")
					
					var inst = afterimage(.03,o)
					inst.speed = 1
					inst = afterimage(.04, o)
					inst.speed = 2
					
					var a = create_anime(0.5)
					.add(1, 4, "linear")
					.add(0, 6, "linear")
					.start(function(v, o) {
						o.flash = v
					}, o)
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
			tp_cost: 0,
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
						
						var a = create_anime(.5)
						.add(1, 4, "linear")
						.add(0, 6, "linear")
						.start(function(v, o) {
							o.flash = v
						}, o)
					}
					for (var i = 0; i < array_length(o_enc.encounter_data.enemies); ++i) {
						if enc_enemy_isfighting(i) {
							if is_instanceof(o_enc.encounter_data.enemies[i], enemy_virovirokun)
								enc_sparepercent_enemy(i, 100)
							else 
								enc_sparepercent_enemy(i, 50)
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
			exec: function(slot){
				enc_sparepercent_enemy(slot, 50)
				encounter_scene_dialogue(loc("enemy_virovirokun_act_susie"))
			},
		},
		ralsei: {
			exec: function(slot){
				enc_sparepercent_enemy(slot, 50)
				encounter_scene_dialogue(loc("enemy_virovirokun_act_ralsei"))
			},
		},
		noelle: {
			exec: function(slot) {
				enc_sparepercent_enemy(slot, 50)
				encounter_scene_dialogue(loc("enemy_virovirokun_act_noelle"))
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
	
	obj = {
        obj: o_actor_e_killercar,
        var_struct: {
            s_hurt: spr_e_killercar_hurt,
            s_spared: spr_e_killercar_hurt,
        }
    }
	tired = true
	defense = 0
    can_spare = false
    turn_object = o_ex_turn_complex_box
    
    hp = 600
    max_hp = 600
	
	acts = [
		{
			name: "Check",
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
			exec: function(slot, user) {
				cutscene_create()
				cutscene_set_variable(o_enc, "waiting", true)
				
				cutscene_dialogue([
					"{char(susie, 21)}* I have an idea.",
				])
				cutscene_set_partysprite(party_getpos("susie"), "spell")
				cutscene_sleep(30)
				cutscene_func(enc_hurt_enemy, [slot, 100 * party_getdata("susie", "attack") * party_getdata("susie", "magic"), user, snd_damage, 0, 0, true])
				cutscene_sleep(30)
				
				cutscene_set_variable(o_enc, "waiting", false)
				cutscene_play()
				
			}
		},
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
            var inst = instance_create(o_dummy, __enemy.x - 50, __enemy.y - __enemy.myheight/2, __enemy.depth - 50, {
                sprite_index: spr_ex_almond_milk
            })
            do_animate(2.5, 1, 10, "linear", inst, "image_xscale")
            do_animate(2.5, 1, 10, "linear", inst, "image_yscale")
            do_animate(0, 1, 10, "linear", inst, "image_alpha")
            
            my_inst_almond = inst
        }), [actor_id])
        cutscene_sleep(15)
        
        cutscene_func(method(self, function(__enemy) {
            do_animate(my_inst_almond.x, __enemy.x, 10, "cubic_in", my_inst_almond, "x")
            do_animate(1, 0, 10, "cubic_in", my_inst_almond, "image_alpha")
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
            instance_create(o_text_hpchange, o.x, o.y - o.myheight/2, o.depth-100, {
				draw: 300, 
				mode: 0
			})
        }, [actor_id])
        cutscene_animate(1, 0, 10, "linear", actor_id, "flash")
        
        cutscene_wait_dialogue_finish()
        cutscene_set_variable(o_enc, "waiting", false)
        cutscene_play()
    })
    
    recruit = new enemy_recruit_killercar()
}