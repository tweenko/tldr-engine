function ex_enemy_shadowguy() : enemy_base() constructor{
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
				cutscene_set_variable(o_enc, "exec_wait", true)
				
				cutscene_sleep(10)
				
				var dia = "* Aim with " + input_binding_intext(["left", "right"])
				dia += " and " + input_binding_intext(["up", "down"]) + "! "
				dia += "{br}{resetx}{s(10)}* Fire with " + input_binding_intext("menu") + "!{stop}"
				
				cutscene_dialogue(dia, "", false)
				
				cutscene_instance_create(o_ex_enc_m_shooter, me.actor_id.x, guipos_y()+100,, {
					shoot_sprites: me.shoot_sprites
				})
				cutscene_wait_until(function(){
					return !instance_exists(o_ex_enc_m_shooter)
				})
				
				cutscene_func(function(){instance_destroy(o_ui_dialogue)})
				cutscene_sleep(30)
				
				cutscene_set_variable(o_enc, "exec_wait", false)
				cutscene_play()
			}
		}
	]
	
	//recruit
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
		
	//text
	dialogue = function(slot){
	}
	flavor = function(slot){
		var text = ""
		var priority = 0 //the higher, the more likely to appear
		if o_enc.encounter_data.enemies[slot].mercy >= 100 
            text = "* Shadowguy shuffles their feet in a celebratory manner."
		if text == "" {
			var a = [
				"* Smells like jam."
			]
			
			if o_enc.encounter_data.debug_name == "shadowguys" 
                array_push(a, "* Shadowguys argue over who gets the next solo.")
			text = a[irandom(array_length(a)-1)]
		}
		
		if o_enc.encounter_data.enemies[slot].hp <= o_enc.encounter_data.enemies[slot].max_hp/3 {
			text = "* Shadowguy skips a beat!"
			priority = 1
		}
		return {
			text,
			priority,
		}
	}
}