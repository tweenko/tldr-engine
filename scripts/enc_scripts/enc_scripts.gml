///@desc returns the battle sprite of a party member from the battle_sprites struct inside party data
function enc_getparty_sprite(party_name, sprname) {
	var ret = struct_get(party_getdata(party_name, "battle_sprites"), sprname)
	
	if is_array(ret) 
		ret = ret[0]
	party_get_inst(party_name).sprname = sprname
	
    if !sprite_exists(ret)
        return undefined
	ret = asset_get_index_state(sprite_get_name(ret), party_getdata(party_name, "s_state"))
	
	return ret
}

/// @desc  hurts an enemy and makes it run away if needed. if the damage is FATAL, specify in the optional argument
/// @param {real} target_index
/// @param {real} hurt_amount
/// @param {string} party_name
/// @param {asset.GMSound} [sfx]
/// @param {bool} [fatal]
/// @param {string} [seed]
function enc_hurt_enemy(target, hurt, user, sfx = undefined, fatal = false, seed = "") {
	var enemy_struct = o_enc.encounter_data.enemies[target]
    hurt = round(hurt)
    sfx ??= enemy_struct.hurt_sound
    
    if struct_exists(enemy_struct, "ev_hurt") && is_callable(enemy_struct.ev_hurt)
        enemy_struct.ev_hurt()
    
    if !is_struct(enemy_struct)
        exit
    if enemy_struct.hp <= 0 || !enc_enemy_isfighting(target)
		exit
	enemy_struct.hp -= hurt
	
	var o = enemy_struct.actor_id
	var txt = -hurt
    
	if hurt == 0
		txt = "miss"
	
	if !instance_exists(o) 
		exit
	instance_create(o_text_hpchange, o.x, o.s_get_middle_y(), o.depth-100, {draw: txt, mode: TEXT_HPCHANGE_MODE.ENEMY, user: user,})
	
	if hurt > 0 {
		if enemy_struct.hp <= 0 {
			if fatal
                enemy_struct.__fatal_defeat()
			else if seed == "" {
                enemy_struct.__run_defeat()
                
                if !recruit_islost(enemy_struct) {
                    instance_create(o_text_hpchange, o.x, o.s_get_middle_y(), o.depth - 100, {
                        draw: "lost",
                        mode: TEXT_HPCHANGE_MODE.SCALE,
                    })
                    recruit_lose(enemy_struct)
                }
			}
            else if seed == "freeze"
                enemy_struct.__freeze_defeat()
		}
		else if enemy_struct.hp < enemy_struct.max_hp * enemy_struct.low_hp_tired_threshold && enemy_struct.low_hp_tired
            enemy_struct.tired = true
        
        if instance_exists(o) 
			o.hurt = 20
		audio_play(sfx)
		
		animate(6, 0, 10, anime_curve.linear, o, "shake")
	}
}

/// @desc adds to the mercy bar and spawns a text indicator
/// @arg {real} target_index the index of the target enemy
/// @arg {real} percent the amount of percent to add
/// @arg {Asset.GMSound} sfx the sfx to play upon adding the percentage
function enc_enemy_add_spare(target, percent, sfx = snd_mercyadd) {
    if !enc_enemy_isfighting(target)
        exit
    
	o_enc.encounter_data.enemies[target].mercy += percent
	if o_enc.encounter_data.enemies[target].mercy >= 100
		percent = 100
	
	o_enc.encounter_data.enemies[target].mercy = clamp(o_enc.encounter_data.enemies[target].mercy, 0, 100)
	
	var o = o_enc.encounter_data.enemies[target].actor_id
	var txt = $"+{percent}%"
	
	instance_create(o_text_hpchange, o.x, o.s_get_middle_y(), o.depth - 100, {draw: txt, mode: TEXT_HPCHANGE_MODE.PERCENTAGE})
	
	if sfx == snd_mercyadd {
		var _pitch = 0.8
		
        if percent <= 25
            _pitch = 1.4
        else if percent <= 50
            _pitch = 1.2
        else if percent < 100
            _pitch = 1
			
        audio_play(sfx,, 0.8, _pitch, 1)
	}
	if o_enc.encounter_data.enemies[target].mercy >= 100 {
        o_enc.encounter_data.enemies[target].s_idle = o_enc.encounter_data.enemies[target].s_spare
        o.sprite_index = o_enc.encounter_data.enemies[target].s_spare
    }
}

/// @desc adds to the mercy bar and spawns a text indicator
/// @arg {real} target_index the index of the target enemy
/// @arg {Id.Instnace} instance the instance that holds the percentage variable
/// @arg {string} var_name the name of the variable that holds the target percentage
/// @arg {Asset.GMSound} sfx the sfx to play upon adding the percentage
function enc_enemy_add_spare_from_var(target, instance, variable, sfx = snd_mercyadd){
	var percent = variable_instance_get(instance, variable)
	enc_enemy_add_spare(target, percent, sfx)
}

/// @desc sets the enemy's tired variable to true
/// @arg {real} enemy_index the index of the enemy that is to become tired/not-tired
/// @arg {bool} _tired whether the enemy should become tired or not
function enc_enemy_set_tired(enemy_index, _tired) {
    if !instance_exists(o_enc)
        exit
    if !enc_enemy_isfighting(enemy_index)
        exit
    
    o_enc.encounter_data.enemies[enemy_index].tired = _tired
}

///@desc clamps a value between 0 and 100
function tp_clamp(tp) {
	return clamp(tp, 0, 100)
}

/// @desc returns whether an enemy is still fighting
/// @arg enemy_slot
function enc_enemy_isfighting(target) {
    if target >= array_length(o_enc.encounter_data.enemies) || target < 0
        return false
    
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
    if instance_exists(o_gameover)
        exit
    
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

/// @arg {string} party_name party member name
/// @arg {Asset.GMSprite|string} sprite_ref the sprite to use. can be either a string that will be put into `enc_getparty_sprite` or a sprite index
/// @arg {real} index the image index of the sprite, by default doesn't change it
/// @arg {real} speed the speed of the sprite, by default doesn't change it
function enc_party_set_battle_sprite(party_name, sprite_ref, index = undefined, speed = undefined) {
    index ??= 0; speed ??= 1
    
    var inst = party_get_inst(party_name)
    if is_string(sprite_ref) {
        var target_sprite = enc_getparty_sprite(party_name, sprite_ref)
        inst.sprite_index = (sprite_exists(target_sprite) ? target_sprite : inst.sprite_index)
    }
    else if sprite_exists(sprite_ref)
        inst.sprite_index = sprite_ref
    
    if !is_undefined(index)
        inst.image_index = index
    if !is_undefined(speed)
        inst.image_speed = speed
}

/// @desc returns whether an enemy is recruitable
/// @arg {function|struct.enemy} ref_or_struct
/// @return {bool}
function enc_enemy_is_recruitable(ref_or_struct) {
    if is_callable(ref_or_struct)
        ref_or_struct = new ref_or_struct()
    
    return is_struct(ref_or_struct.recruit)
}

function enc_get_flavor(data) {
    if is_callable(data.flavor)
        return data.flavor()
    return data.flavor
}

/// @desc returns the amount of enemies that are currently fighting
function enc_count_fighting_enemies() {
    var count = 0
    for (var i = 0; i < array_length(o_enc.encounter_data.enemies); i ++) {
        if enc_enemy_isfighting(i)
            count ++
    }
    return count
}

/// @arg {struct.enc_set|function} set_or_ref the encounter set struct or its reference
/// @arg {function} enemy_ref the enemy we're looking for
function enc_set_contains_enemy(set_or_ref, enemy_ref) {
    if !is_struct(set_or_ref)
        set_or_ref = new set_or_ref()
    
    for (var i = 0; i < array_length(set_or_ref.enemies); i ++) {
        if enc_enemy_isfighting(i) && is_instanceof(set_or_ref.enemies[i], enemy_ref)
            return true
    }
}
/// @arg {struct.enc_set|function} set_or_ref the encounter set struct or its reference
/// @arg {function} enemy_ref the enemy we're counting
function enc_set_count_enemy(set_or_ref, enemy_ref) {
    if !is_struct(set_or_ref)
        set_or_ref = new set_or_ref()
    
    var counter = 0
    for (var i = 0; i < array_length(set_or_ref.enemies); i ++) {
        if enc_enemy_isfighting(i) && is_instanceof(set_or_ref.enemies[i], enemy_ref)
            counter ++
    }
    return counter
}

/// @desc returns whether an item in the item selector page of the encounter ui can be used
/// @arg {struct} item_struct the struct of the item you'd like to check
function enc_item_get_enabled(item_struct) {
    var can_perform = true
    
    // disable the act if some member is not up
    if struct_exists(item_struct, "party") {
        if item_struct.party == -1 {
            for (var j = 0; j < party_length(); j ++) {
                if !party_isup(global.party_names[j]) {
                    can_perform = false
                    break
                }
            }
        }
        else {
            for (var j = 0; j < array_length(item_struct.party); j ++) {
                var name = item_struct.party[j]
                if !party_isup(name) {
                    can_perform = false
                    break
                }
            }
        }
    }
    
    if struct_exists(item_struct, "tp_cost") {
        if item_struct.tp_cost > o_enc.tp
            can_perform = false
    }
    if struct_exists(item_struct, "enabled") {
        if is_bool(item_struct.enabled)
            can_perform = item_struct.enabled
        else if is_callable(item_struct.enabled)
            can_perform = item_struct.enabled
    }
    
    return can_perform
}

enum ENC_TARGET {
    RANDOM,
    ANY,
    ALL,
}

/// @desc caclulates a target during an encounter based on the struct
/// @arg {struct.enc_set} encounter the encounter struct
function enc_calculate_target(encounter) {
    if encounter.target_calculation == ENC_TARGET.ALL {
        var __targets = []
        for (var i = 0; i < party_length(); ++i) {
		    if party_getdata(global.party_names[i], "hp") > 0
				array_push(__targets, global.party_names[i])
		}
        
        return __targets
    } 
    else if encounter.target_calculation == ENC_TARGET.RANDOM || encounter.target_calculation == ENC_TARGET.ANY {
        var __targets = []
        for (var i = 0; i < party_length(); ++i) {
		    if party_getdata(global.party_names[i], "hp") > 0
				array_push(__targets, global.party_names[i])
		}
        
        if array_length(__targets) == 0
            return -1
        return [array_shuffle(__targets)[0]]
    }
    else {
        return encounter.target_calculation()
    }
}
/// @desc returns whether a target should be recalculated
/// @arg {struct.enc_set} encounter the encounter struct
/// @arg {array} current_targets the current turn targets
function enc_recalculate_condition(encounter, current_targets) {
    if !struct_exists(encounter, "target_recalculate_condition")
        return false
    
    if !is_real(encounter.target_recalculate_condition) && is_callable(encounter.target_recalculate_condition) 
        return encounter.target_recalculate_condition(current_targets)
    
    else if encounter.target_calculation == ENC_TARGET.ALL
        return false
    else if encounter.target_calculation == ENC_TARGET.RANDOM
        return (!party_isup(current_targets[0]) ? true : false)
    else if encounter.target_calculation == ENC_TARGET.ANY
        return true
}