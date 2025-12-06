event_inherited()

interaction_code = function() {
    var __mode = state_get("test_couchsat", id)
    var sitting = []
    
    if party_ismember("kris")
        array_push(sitting, "kris")
    if party_ismember("susie")
        array_push(sitting, "susie")
    if party_ismember("ralsei")
        array_push(sitting, "ralsei")
    
    cutscene_create()
    cutscene_player_canmove(false)
    cutscene_party_follow(false)
    
    cutscene_set_variable(o_camera, "target", noone)
    
    if array_length(sitting) == 1 && sitting[0] = "kris" { }
    else {
        cutscene_audio_play(snd_jump)
        cutscene_func(function(xx, yy, _depth) {
            var __put = function(name, xx, yy, _depth) {
                var _inst = party_get_inst(name)
                
                var _anim_x = animate(_inst.x, xx, 15, "linear", _inst, "x")
                var _anim_y = animate(_inst.y, yy - 30, 10, "cubic_out", _inst, "y")
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
            if party_ismember("noelle")
                actor_move(o_actor_noelle, new actor_movement(xx, yy + 40, 20,,, DIR.UP))
            
        }, [x, y, depth])
        cutscene_sleep(20)
        
        cutscene_audio_play(snd_noise)
        cutscene_func(function() {
            var __put = function(name) {
                var _inst = party_get_inst(name)
                
                _inst.sprite_index = asset_get_index($"spr_{name}_sit")
                _inst.image_index = 0
                _inst.image_speed = 0
                
                animate(5, 0, 10, "linear", _inst, "shake")
            }
            
            if party_ismember("susie")
                __put("susie")
            if party_ismember("ralsei")
                __put("ralsei")
        })
        cutscene_sleep(20)
        
        if !__mode {
            cutscene_sleep(30)
            
            if party_ismember("ralsei")
                cutscene_dialogue("{char(ralsei, 20)}* Kris, are you joining us, or..?")
            if party_ismember("susie")
                cutscene_dialogue([
                    "{char(susie, 1)}* Hey, when we get couch time we ALL get couch time.",
                    "{face_ex(21)}* ...",
                    "{face_ex(10)}* Kris, you too."
                ])
            
            state_add("test_couchsat", id)
        }
    }
    
    cutscene_func(function(ddepth) {
        var _inst = party_get_inst("kris")
        _inst.custom_depth = ddepth - 10
    }, [depth])
    cutscene_actor_move(o_actor_kris, new actor_movement(x, y - 5, 20,, DIR.UP))
    
    cutscene_audio_play(snd_noise)
    cutscene_func(function() {
        var _inst = party_get_inst("kris")
        
        _inst.s_override = true
        _inst.sprite_index = asset_get_index($"spr_kris_sit")
        _inst.y -= 5
        
        _inst.image_index = 0
        _inst.image_speed = 0
        
        animate(5, 0, 10, "linear", _inst, "shake")
    })
    cutscene_sleep(5)
    
    if !__mode && party_ismember("noelle") {
        if party_ismember("susie") {
            cutscene_dialogue([
                "{char(noelle, 17)}* (Um...)",
                "{char(susie, 10)}* Noelle, did you say something? I didn't hear much if you did.",
                "{char(noelle, 18)}* Oh, no. I... Uh...",
                "{char(susie, 2)}* Cool.{mini(`(I'll just... sit here.)`, noelle, 6)}",
            ])
        }
        else if party_ismember("ralsei") {
            cutscene_dialogue([
                "{char(noelle, 17)}* (Um...)",
                "{char(ralsei, 3)}* Kris, are you cozy?{mini(`(I'll just... sit here.)`, noelle, 6)}",
            ])
        }
        else {
            cutscene_dialogue([
                "{char(noelle, 17)}* ...",
            ])
        }
    }
    
    if party_ismember("noelle") {
        var o = party_get_inst("noelle")
        cutscene_actor_move(o, new actor_movement(0, 10, 15,,, DIR.UP, false))
        cutscene_sleep(10)
        cutscene_set_variable(o, "s_override", true)
        cutscene_set_variable(o, "sprite_index", spr_noelle_sit_up)
        cutscene_audio_play(snd_noise)
    }
    
    cutscene_wait_until(function() {
        return InputCheck(INPUT_VERB.SELECT) || InputCheck(INPUT_VERB.CANCEL)
    })
    for (var i = 0; i < array_length(sitting); i ++) {
        cutscene_func(function(i, sitting) {
            var o = party_get_inst(sitting[i])
            o.s_override = false
            
            audio_play(snd_noise)
            actor_move(o, new actor_movement(get_leader().x, get_leader().y + 40 - i * 24, 20))
        }, [i, sitting])
        cutscene_sleep(5)
    }
    if party_ismember("noelle") {
        var o = party_get_inst("noelle")
        cutscene_set_variable(o, "s_override", false)
        cutscene_audio_play(snd_noise)
        cutscene_sleep(5)
    }
    cutscene_sleep(30)
    
    cutscene_func(function(sitting) {
        for (var i = 0; i < array_length(sitting); i ++) {
            party_get_inst(sitting[i]).custom_depth = undefined
        }
        camera_unpan(get_leader(), 20)
    }, [sitting])
    cutscene_sleep(20)
    
    cutscene_party_interpolate()
    cutscene_player_canmove(true)
    cutscene_party_follow(true)
    cutscene_play()
}