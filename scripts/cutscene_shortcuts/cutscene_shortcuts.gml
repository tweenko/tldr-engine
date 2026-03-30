/// @arg {real,array} index could be a single index or an array of indexes if there are multiple enemies to spare
function cutscene_spare_enemy(index) {
    if !is_array(index)
        index = [index]
    
    for (var i = 0; i < array_length(index); i ++) {
        var _enemy = o_enc.encounter_data.enemies[index[i]]
        var obj = _enemy.actor_id
        
        if !enc_enemy_isfighting(index[i])
            continue
        
        recruit_advance(_enemy)
        
        cutscene_set_variable(obj, "sprite_index", _enemy.s_spare)
        if !recruit_islost(_enemy) && enc_enemy_is_recruitable(_enemy)
           cutscene_instance_create(o_text_hpchange, 
               obj.x, obj.s_get_middle_y(), 
               obj.depth - 100, {
                   draw: $"{recruit_get_progress(_enemy)}/{recruit_getneed(_enemy)}", 
                   mode: TEXT_HPCHANGE_MODE.RECRUIT
               }
           )
        
        // flash the enemy
        cutscene_anim(.5, 1, 4, "linear", method({obj}, function(val) {
            if instance_exists(obj) 
                obj.flash = val
        }))
    }
    
    cutscene_audio_play(snd_spare)
    cutscene_sleep(4)
    
    for (var i = 0; i < array_length(index); i ++) {
        var _enemy = o_enc.encounter_data.enemies[index[i]]
        var obj = _enemy.actor_id
        
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

/// @desc turns an actor's `s_override` variable on or off
/// @arg {Asset.GMObject,Id.Instance} actor_inst
/// @arg {bool} override true to override, false to make it normal
function cutscene_actor_override(actor_inst, override) {
    cutscene_set_variable(actor_inst, "s_override", override)
}