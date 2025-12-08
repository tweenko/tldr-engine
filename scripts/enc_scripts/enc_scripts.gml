///@desc returns the battle sprite of a party member from the battle_sprites struct inside party data
function enc_getparty_sprite(index, sprname) {
	var ret = struct_get(party_getdata(global.party_names[index], "battle_sprites"), sprname)
	
	if is_array(ret) 
		ret = ret[0]
	party_get_inst(global.party_names[index]).sprname = sprname
	
	ret = asset_get_index_state(sprite_get_name(ret), party_getdata(global.party_names[index], "s_state"))
	
	return ret
}

/// @desc  hurts an enemy and makes it run away if needed. if the damage is FATAL, specify in the optional argument
/// @param {real} target_index
/// @param {real} hurt 
/// @param {real} user_index
/// @param {asset.gmsound} [sfx]
/// @param {real} [xoff]
/// @param {real} [yoff]
/// @param {bool} [fatal]
/// @param {string} [seed]
function enc_hurt_enemy(target, hurt, user, sfx = snd_damage, xoff = 0, yoff = 0, fatal = false, seed = "") {
	if o_enc.encounter_data.enemies[target].hp <= 0 
		exit
	o_enc.encounter_data.enemies[target].hp -= hurt
	
	var o = o_enc.encounter_data.enemies[target].actor_id
	var txt = -hurt
	if hurt == 0
		txt = "miss"
	
	if !instance_exists(o) 
		exit
	instance_create(o_text_hpchange, o.x + xoff, o.y - o.myheight/2 + yoff, o.depth-100, {draw: txt, mode: 1, user: global.party_names[user],})
	
	if hurt > 0 {
		if o_enc.encounter_data.enemies[target].hp <= 0 {
			if fatal {
				instance_create(o_eff_fatal_damage, o.x, o.y, o.depth, {
					sprite_index: o.s_hurt,
					image_xscale: o.image_xscale,
					image_yscale: o.image_yscale,
					image_index: o.image_index,
					image_speed: 0,
					shake: 6,
				})
				instance_destroy(o)
			}
			else if seed == "" {
				o.run_away = true
				audio_play(snd_defeatrun)
                
                if !recruit_islost(o_enc.encounter_data.enemies[target]) {
                    instance_create(o_text_hpchange, o.x, o.y - o.myheight/2, o.depth - 100, {
                        draw: "lost",
                        mode: 4,
                    })
                    recruit_lose(o_enc.encounter_data.enemies[target])
                }
			}
            else if seed == "freeze" {
                animate(0, 1, 20, "linear", o, "freeze")
                
                instance_create(o_text_hpchange, o.x, o.y - o.myheight/2, o.depth - 100, {
                    draw: "frozen",
                    mode: 4,
                })
                audio_play(snd_petrify)
            }
		}
		if instance_exists(o) 
			o.hurt = 20
		audio_play(sfx)
		
		animate(6, 0, 10, anime_curve.linear, o, "shake")
	}
}

///@desc adds to the mercy bar and makes the enemy spareable if needed
///@arg slot
function enc_sparepercent_enemy(target, percent, sfx = snd_mercyadd) {
	o_enc.encounter_data.enemies[target].mercy += percent
	if o_enc.encounter_data.enemies[target].mercy >= 100
		percent = 100
	
	o_enc.encounter_data.enemies[target].mercy = clamp(o_enc.encounter_data.enemies[target].mercy, 0, 100)
	
	var o = o_enc.encounter_data.enemies[target].actor_id
	var txt = $"+{percent}%"
	
	instance_create(o_text_hpchange, o.x, o.y - o.myheight/2, o.depth - 100, {draw: txt, mode: 2})
	
	if sfx == snd_mercyadd {
		var _pitch = 0.8
		
        if percent < 99
            _pitch = 1
        if percent <= 50
            _pitch = 1.2
        if percent <= 25
            _pitch = 1.4
			
        audio_play(sfx,, 0.8, _pitch, 1)
	}
	if o_enc.encounter_data.enemies[target].mercy >= 100 {
		o.sprite_index = o.s_spared
	}
}

///@arg slot
function enc_sparepercent_enemy_from_inst(target, instance, variable, sfx = snd_mercyadd){
	var percent = variable_instance_get(instance, variable)
	enc_sparepercent_enemy(target, percent, sfx)
}

///@desc clamps a value between 0 and 100
function tp_clamp(tp) {
	return clamp(tp, 0, 100)
}

/// @desc returns whether an enemy is still fighting
/// @arg enemy_slot
function enc_enemy_isfighting(target) {
	var ret = is_struct(o_enc.encounter_data.enemies[target])
	if ret && o_enc.encounter_data.enemies[target].hp <= 0 
		ret = false
	
	return ret
}	

///@desc starts an encounter
function enc_start(set) {
	var inst = instance_create(o_enc_anim, get_leader().x, get_leader().y,, {encounter_data: set})
	return inst
}

///@desc returns the enemy count during the current encounter
function enc_enemy_count(only_alive = true) {
	if only_alive {
		var c = 0
		for (var i = 0; i < array_length(o_enc.encounter_data.enemies); ++i) {
		    if enc_enemy_isfighting(i) 
				c ++
		}
		return c
	}
	return array_length(o_enc.encounter_data.enemies)
}

///@desc game over!
function enc_gameover(){
	instance_create(o_gameover, 
		o_enc_soul.x - guipos_x(), o_enc_soul.y - guipos_y(), DEPTH_ENCOUNTER.UI,
		{ 
			image_blend: o_enc_soul.image_blend,
			freezeframe: sprite_create_from_surface(application_surface, 0, 0, 640, 480, 0, 0, 0, 0),
			freezeframe_gui: sprite_create_from_surface((instance_exists(o_enc) ? o_enc.surf : -1), 0, 0, 640, 480, 0, 0, 0, 0),
		}
	)
	
	room_goto(room_gameover)
	
	audio_stop_all()
	audio_play(snd_hurt)
}

/// @arg {real,array} index could be an index or array if there are multiple enemies to spare
function cutscene_spare_enemy(index) {
    var _enemy = o_enc.encounter_data.enemies
    
    if !is_array(index)
        index = [index]
    
    for (var i = 0; i < array_length(index); i ++) {
        var obj = _enemy[index[i]].actor_id
        
        if !enc_enemy_isfighting(index[i])
            continue
        
        recruit_advance(_enemy[index[i]])
        
        cutscene_set_variable(obj, "sprite_index", obj.s_spared)
        if !recruit_islost(_enemy[index[i]])
           cutscene_instance_create(o_text_hpchange, 
               obj.x, obj.y - obj.myheight/2, 
               obj.depth - 100, {
                   draw: $"{recruit_get_progress(_enemy[index[i]])}/{recruit_getneed(_enemy[index[i]])}", 
                   mode: 3
               }
           )
        
        // flash the enemy
        cutscene_anim(.5, 1, 4, "linear", function(v, o) {
            if instance_exists(o) 
                o.flash = v
        }, obj)
    }
    
    cutscene_audio_play(snd_spare)
    cutscene_sleep(4)
    
    for (var i = 0; i < array_length(index); i ++) {
        var obj = _enemy[index[i]].actor_id
        
        cutscene_instance_create(o_afterimage, obj.x, obj.y, obj.depth + 6, {
            sprite_index: obj.sprite_index, 
            image_index: obj.image_index, 
            white: true, 
            image_alpha: 1, 
            speed: 2
        })
        cutscene_instance_create(o_afterimage, obj.x, obj.y, obj.depth + 6, {
            sprite_index: obj.sprite_index,
            image_index: obj.image_index, 
            white: true, 
            image_alpha: 1, 
            speed: 4
        })
        cutscene_instance_create(o_eff_spareeffect, 
            obj.x - obj.sprite_xoffset, obj.y - obj.sprite_yoffset,
            obj.depth - 6, {
                w: obj.sprite_width,
                h: obj.sprite_height
            }
        )
        
        cutscene_func(instance_destroy, [obj])
        cutscene_func(function(e) {
            o_enc.encounter_data.enemies[e] = "spared"
        }, [index[i]])
    }
}