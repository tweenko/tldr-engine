global.party_names = ["kris", "susie", "ralsei"]

var inst = actor_create(party_get_obj("noelle"), 110, 270)
inst.s_override = true
inst.sprite_index = spr_noelle_fallen
inst.image_speed = 0

party_setdata("noelle", "hp", 70)

trigger_code = function() {
    cutscene_create()
    cutscene_player_canmove(false)
    cutscene_party_follow(false)
    cutscene_set_variable(o_camera, "target", noone)
    
    cutscene_func(function() {
        party_set_state("susie", "serious")
    })
    cutscene_dialogue("{char(susie, 28)}* Woah... Is that...",, false)
    for (var i = 0; i < array_length(global.party_names); i ++) {
        cutscene_actor_move(party_get_inst(global.party_names[i]), new __actor_movement(
            110 - (array_length(global.party_names) - 1) * 20 + i * 40,
            150,
            30,,, DIR.DOWN
        ), i, (i == array_length(global.party_names) - 1 ? true : false))
    }
    cutscene_wait_dialogue_finish()
    
    for (var i = 0; i < array_length(global.party_names); i ++) {
        cutscene_actor_move(party_get_inst(global.party_names[i]), new __actor_movement(
            0,
            90,
            20,,, DIR.DOWN, false
        ), i, false)
    }
    cutscene_camera_pan(undefined, 220, 30)
    
    cutscene_actor_move(party_get_inst("susie"), new __actor_movement(
        0,
        5,
        10,,, DIR.DOWN, false
    ), i, false)
    cutscene_dialogue([
        "{char(susie, 29)}* Noelle??",
        "{char(noelle, 27)}* WHO'S NOELLE?"
    ],, false, false)
    cutscene_wait_dialogue_boxes(1)
    cutscene_set_variable(o_actor_noelle, "image_index", 3)
    cutscene_audio_play(snd_noise)
    cutscene_sleep(5)
    
    cutscene_audio_play(snd_whip_hard)
    cutscene_set_variable(party_get_inst("susie"), "sprite_index", spr_susie_sheeh)
    cutscene_set_variable(party_get_inst("susie"), "s_override", true)
    cutscene_animate(5, 0, 10, "linear", party_get_inst("susie"), "shake")
    cutscene_wait_dialogue_finish()
    
    cutscene_set_variable(o_actor_noelle, "image_index", 0)
    cutscene_sleep(50)
    
    cutscene_set_variable(party_get_inst("susie"), "image_xscale", 1)
    cutscene_set_variable(party_get_inst("susie"), "sprite_index", spr_susie_down)
    cutscene_set_variable(party_get_inst("susie"), "s_override", false)
    cutscene_audio_play(snd_noise)
    cutscene_set_variable(o_actor_noelle, "sprite_index", spr_noelle_shock)
    cutscene_animate(5, 0, 10, "linear", o_actor_noelle, "shake")
    cutscene_dialogue([
        "{char(noelle, 10)}* Ha-h-- I MEAN-- Uh-",
        "{face_ex(6)}* HEY SUSIE"
    ],, true, false)
    cutscene_sleep(30)
    
    cutscene_func(function() {
        party_set_state("susie", "")
    })
    cutscene_dialogue([
        "{char(susie, 25)}* Hey."
    ],,, false)
    cutscene_sleep(10)
    
    cutscene_set_variable(o_actor_noelle, "sprite_index", spr_noelle_up)
    cutscene_dialogue([
        "{char(noelle, 3)}* ...", 
        "{char(susie, 27)}* ...",
        "{char(noelle, 6)}* ..."
    ],,, false)

    cutscene_sleep(30)
    cutscene_dialogue([
        "{char(susie, 27)}* So like, why were you...",
        "{face_ex(26)}* ...on the floor?"
    ],,, false)
    
    cutscene_sleep(30)
    cutscene_dialogue([
        "{char(noelle, 31)}* I just got really lost in this test place and... fell asleep, haha!",
        "{char(susie, 30)}* Oh, did you have like, any dreams??",
        "{char(noelle, 24)}* Yeah! The dream was cool... there was, like...",
        "{face_ex(3)}* Um...",
    ],, false, false)
    cutscene_wait_dialogue_boxes(2)
    
    cutscene_set_variable(o_actor_noelle, "sprite_index", spr_noelle_right)
    cutscene_wait_dialogue_boxes(1)
    
    cutscene_set_variable(o_actor_noelle, "sprite_index", spr_noelle_right_blush)
    cutscene_wait_dialogue_finish()
    
    cutscene_sleep(40)
    cutscene_dialogue([
        "{char(susie, 32)}* Sorry, uhh... I don't think I heard that last part.",
        "{char(noelle, 27)}* ANYWAY, guys, mind if tag along?",
        "{char(susie, 26)}* Uhh, sure?"
    ],, false, false)
    cutscene_wait_dialogue_boxes(1)
    
    cutscene_set_variable(o_actor_noelle, "sprite_index", spr_noelle_up)
    cutscene_wait_dialogue_finish()
    
    cutscene_camera_pan(undefined, 320, 30, false)
    
    cutscene_set_variable(o_actor_noelle, "sprite_index", spr_noelle_down)
    for (var i = 0; i < array_length(global.party_names); i ++) {
        cutscene_actor_move(party_get_inst(global.party_names[i]), [
            new __actor_movement(80, 150 + 90, 20),
            new __actor_movement(110, 340 - i * 25, 40)
        ], i, (i == array_length(global.party_names) - 1 ? true : false))
        cutscene_sleep(10)
    }
    
    cutscene_audio_play(mus_charjoin)
    cutscene_dialogue("* (Noelle joined your party.)")
    
    cutscene_func(function() {
        var inst = o_actor_noelle.id
        
        array_push(global.party_names, "noelle")
        party_member_create("noelle", true, inst.x, inst.y)
        instance_destroy(inst)
    })
    
    cutscene_party_follow(true)
    cutscene_party_interpolate()
    cutscene_player_canmove(true)
    cutscene_play()
}