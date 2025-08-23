event_inherited()

interaction_code = function() {
    cutscene_create()
    cutscene_player_canmove(false)
    cutscene_party_follow(false)
    
    cutscene_set_variable(o_camera, "target", noone)
    
    cutscene_audio_play(snd_jump)
    cutscene_func(function(xx, yy, _depth) {
        var __put = function(name, xx, yy, _depth) {
            var _inst = party_get_inst(name)
            
            var _anim_x = do_animate(_inst.x, xx, 15, "linear", _inst, "x")
            var _anim_y = do_animate(_inst.y, yy - 30, 10, "cubic_out", _inst, "y")
                .add(yy - 5, 5, "sine_in")
            
            _inst.custom_depth = _depth - 10 + party_getpos(name)
            
            _inst.sprite_index = _inst.s_ball
            _inst.image_speed = 1
            _inst.s_override = true
        }
        
        if party_ismember("susie")
            __put("susie", xx - 16, yy, _depth)
        if party_ismember("ralsei")
            __put("ralsei", xx + 16, yy, _depth)
        
    }, [x, y, depth])
    cutscene_sleep(15)
    
    cutscene_audio_play(snd_noise)
    cutscene_func(function() {
        var __put = function(name) {
            var _inst = party_get_inst(name)
            
            _inst.sprite_index = asset_get_index($"spr_{name}_sit")
            _inst.image_index = 0
            _inst.image_speed = 0
            
            do_animate(5, 0, 10, "linear", _inst, "shake")
        }
        
        if party_ismember("susie")
            __put("susie")
        if party_ismember("ralsei")
            __put("ralsei")
    })
    cutscene_sleep(20)
    
    cutscene_func(function() {
        var _inst = party_get_inst("kris")
        _inst.custom_depth = -3000
    })
    cutscene_actor_move(o_actor_kris, new __actor_movement(x, y - 5, 20,, DIR.UP))
    
    cutscene_audio_play(snd_noise)
    cutscene_func(function() {
        var _inst = party_get_inst("kris")
        
        _inst.s_override = true
        _inst.sprite_index = asset_get_index($"spr_kris_sit")
        _inst.y -= 5
        
        _inst.image_index = 0
        _inst.image_speed = 0
        
        do_animate(5, 0, 10, "linear", _inst, "shake")
    })
    cutscene_sleep(5)
    
    cutscene_wait_until(function() {
        return InputCheck(INPUT_VERB.SELECT) || InputCheck(INPUT_VERB.CANCEL)
    })
    for (var i = 0; i < array_length(global.party_names); i ++) {
        cutscene_func(function(i) {
            var o = party_get_inst(global.party_names[i])
            o.s_override = false
            
            audio_play(snd_noise)
            actor_move(o, new __actor_movement(get_leader().x, get_leader().y + 40 - i * 24, 20))
        }, [i])
        cutscene_sleep(5)
    }
    cutscene_sleep(30)
    
    cutscene_func(function() {
        for (var i = 0; i < array_length(global.party_names); i ++) {
            party_get_inst(global.party_names[i]).custom_depth = undefined
        }
    })
    
    cutscene_party_interpolate()
    cutscene_player_canmove(true)
    cutscene_party_follow(true)
    cutscene_play()
}