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
			exec:	function(){
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
	ev_dialogue =	-1
	ev_turn =		-1
	ev_post_turn =	-1
	
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
				cutscene_set_variable(o_enc, "exec_wait", true)
				
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
				
				cutscene_set_variable(o_enc, "exec_wait", false)
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
				cutscene_set_variable(o_enc, "exec_wait", true)
				
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
				
				cutscene_set_variable(o_enc, "exec_wait", false)
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
	
	obj = o_actor_e_killercar
	tired = true
	defense = 0
    can_spare = false
	
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
				cutscene_set_variable(o_enc, "exec_wait", true)
				
				cutscene_dialogue([
					"{char(susie, 21)}* I have an idea.",
				])
				cutscene_set_partysprite(party_getpos("susie"), "spell")
				cutscene_sleep(30)
				cutscene_func(enc_hurt_enemy, [slot, 100 * party_getdata("susie", "attack") * party_getdata("susie", "magic"), user, snd_damage, 0, 0, true])
				cutscene_sleep(30)
				
				cutscene_set_variable(o_enc, "exec_wait", false)
				cutscene_play()
				
			}
		},
	]
	
	act_desc = array_create(array_length(acts), -1)
	act_desc[1] = "Kill Em with Ralsei"
    
    recruit = new enemy_recruit_killercar()
}