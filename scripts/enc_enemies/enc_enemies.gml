function enemy_base() constructor {
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
	
	// acts
	acts = [
		{
			name:	"Check",
			party:	[],
			desc:	-1,
			exec:	function(){
				encounter_scene_dialogue("* Empty CHECK text.")
			}
		},
	]
	acts_special = {
	}
	acts_special_desc = "Standard"
	
	// text
	dialogue =				"Test" // can be a function (can accept slot argument as arg0)
	dia_bubble_offset =		[0, 0, 0] // x, y, relative to (1 for enemy and 0 for default box pos)
	dia_bubble_sprites =	[spr_ui_enc_dialogue_box, spr_ui_enc_dialogue_spike]
	flavor =				function() {
		var text = ""
		var priority = 0 //the higher, the more likely to appear
		return {
			text,
			priority,
		}
	}
	
	turn_object = o_turn_default
	
    // misc
    freezable = false
    defeat_marker = 0 // marker id
    
	// misc (in-fight events)
	ev_dialogue =	-1
	ev_turn =		-1
	ev_post_turn =	-1
	
	//recruit
	recruit = {
		need: 2,
		
		//display
		name:		"Test",
		desc:		"Description",
		sprite:		spr_e_virovirokun_idle,
		spr_speed:	1,
		bgcolor:	c_aqua,
		chapter:	2,
		
		//stats
		level:		0,
		element:	"NONE:DEBUG",
		like:		"(None)",
		dislike:	"(None)",
		attack:		0,
		defense:	0,
	}
	
	//system
	actor_id =	-1
	slot =		-1
}

function enemy_virovirokun() : enemy_base() constructor{
	name = "Virovirokun"
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
			name: "Check",
			party: [],
			desc: -1,
			exec: function() {
				encounter_scene_dialogue("* Virovirokun - This sick virus needs affordable healthcare.")
			}
		},
		{
			name: "TakeCare",
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
				
				cutscene_dialogue("* You treated Virovirokun with care! It's no longer infectious!")
				
				cutscene_set_variable(o_enc, "exec_wait", false)
				cutscene_play()
			}
		},
		{
			name: "TakeCareX",
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
							if o_enc.encounter_data.enemies[i].name == "Virovirokun" 
								enc_sparepercent_enemy(i, 100)
							else 
								enc_sparepercent_enemy(i, 50)
						}
					}
				}, user)
				cutscene_dialogue("* Everyone treated the enemy with tender loving care!! All the enemies felt great!!!")
				
				cutscene_set_variable(o_enc, "exec_wait", false)
				cutscene_play()
			}
		},
	]
	acts_special = {
		susie: {
			exec: function(slot){
				enc_sparepercent_enemy(slot, 50)
				encounter_scene_dialogue([
					"* Susie commiserated with the enemy!",
					"{char(susie)}{f_ex(smirk)}* Stick it to the man, dude.",
					"* Even if that means cloning yourself, or, whatever.",
				])
			},
		},
		ralsei: {
			exec: function(slot){
				enc_sparepercent_enemy(slot, 50)
				encounter_scene_dialogue([
					"* Ralsei tried to steer the enemy down the right path.",
					"{char(ralsei)}{f_ex(smile)}* Not everybody knows this, but...",
					"{f_ex(blush_smile)}* Crimes are bad. ... Did you know that?",
				])
			},
		},
		noelle: {
			exec: function() {
				enc_sparepercent_enemy(slot, 50)
				encounter_scene_dialogue("* Noelle offered a cold compress!")
			},
		},
	}
	
	// recruit
	recruit = {
		need: 4,
		
		//display
		name: "Virovirokun",
		desc: "idk",
		sprite: spr_e_virovirokun_idle,
		spr_speed: 1,
		bgcolor: c_aqua,
		chapter: 2,
		
		//stats
		level: 7,
		element: "VIRUS",
		like: "Retro Games",
		dislike: "Federal Justice System",
		attack: 8,
		defense: 6,
	}
		
	// text
	dialogue = function(slot) {
		if self.mercy >= 100 {
			return choose("Just what the doctor ordered!", "Kindness is contagious!")
		}
		return choose("I'm the fever, I'm the chill.", 
			"Don't let this bug ya!", 
			"Happy new year 1997!", 
			"I've got a love letter for you."
		)
	}
	flavor = function(slot) {
		var text = ""
		var priority = 0 //the higher, the more likely to appear
		
		if o_enc.encounter_data.enemies[slot].mercy >= 100 
			text = "* Virovirokun looks healthy."
		if text == "" {
			text = choose("* Virovirokun is sweating suspiciously.", 
				"* Virovirokun uses a text document as a tissue.", 
				"* Virovirokun is poking round things with a spear.", 
				"* Virovirokun is beeping a criminal tune.", 
				"* Smells like cherry syrup."
			)
		}
		
		if o_enc.encounter_data.enemies[slot].hp <= o_enc.encounter_data.enemies[slot].max_hp / 3 {
			text = "* Virovirokun looks extra sick."
			priority = 1
		}
		return {
			text,
			priority,
		}
	}
}
function enemy_killercar() : enemy_base() constructor{
	name = "Killer Car"
	
	obj = o_actor_e_killercar
	tired = true
	defense = 0
	
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
					"{char(susie, smile)}* I have an idea.",
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
}