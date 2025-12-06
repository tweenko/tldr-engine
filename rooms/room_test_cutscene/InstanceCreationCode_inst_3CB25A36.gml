instance_deactivate_object(id)

trigger_code = function() {
    cutscene_create()
    cutscene_player_canmove(false)
    cutscene_party_follow(false)
    
    cutscene_set_variable(party_get_inst("susie"), "dir", DIR.LEFT)
    cutscene_set_variable(party_get_inst("noelle"), "dir", DIR.RIGHT)
    cutscene_dialogue([
        "{char(susie, 4)}* So like. If you were dreaming this whole time... why...",
        "* Is your HP not full??",
        "{char(noelle, 1)}* Oh, is it??? Umm... Do you have... any items?"
    ])
    for (var i = 0; i < array_length(global.party_names); i ++) {
        if global.party_names[i] != "susie" && global.party_names[i] != "noelle" {
            cutscene_actor_move(party_get_inst(global.party_names[i]), new actor_movement(
                get_leader().x + 40 - get_leader().spacing*3 * i, get_leader().y - 15,
                30,,, DIR.DOWN
            ), i, false)
        }
        else
            cutscene_actor_move(party_get_inst(global.party_names[i]), new actor_movement(
                get_leader().x + 40 - get_leader().spacing*3 * i, get_leader().y,
                30,,, DIR.RIGHT
            ), i, false)
    }
    
    cutscene_sleep(40)
    
    cutscene_set_variable(party_get_inst("susie"), "s_override", true)
    cutscene_set_variable(o_actor_susie, "sprite_index", spr_susie_arm_cross)
    cutscene_dialogue([
        "{char(susie, 26)}* Heh. You might want to sit down for this. {mini(`(I'd need a chair...)`, noelle, 7)}"
    ])
    
    var __healdir = -1
    
    cutscene_sleep(10)
    cutscene_set_variable(party_get_inst("susie"), "sprite_index", spr_susie_heal)
    cutscene_set_variable(party_get_inst("susie"), "image_speed", 0)
    cutscene_set_variable(party_get_inst("susie"), "image_index", 0)
    cutscene_set_variable(party_get_inst("susie"), "image_xscale", __healdir)
    
    cutscene_set_variable(party_get_inst("noelle"), "s_override", true)
    cutscene_set_variable(party_get_inst("noelle"), "sprite_index", spr_noelle_right_blush)
    
    cutscene_dialogue([
        "{char(susie, 7)}* Check this out!!"
    ])
    cutscene_set_variable(party_get_inst("susie"), "image_speed", 1)
    cutscene_sleep(6)
    
    cutscene_func(function(__healdir) {
        var inst = instance_create(o_dummy, party_get_inst("susie").x + 20 * __healdir, party_get_inst("susie").y - party_get_inst("susie").myheight/2, party_get_inst("susie").depth - 10, {
            sprite_index: spr_ex_susieheal_beam,
            image_xscale: __healdir,
        })
        animate(inst.x, party_get_inst("noelle").x, 30, "linear", inst, "x")
    }, [__healdir])
    cutscene_sleep(30)
    
    cutscene_func(function() {
        party_heal("noelle", item_spell_get_struct(item_s_susieheal, "susie").__heal_calc("susie"))
        instance_destroy(o_dummy)
    })
    cutscene_set_variable(party_get_inst("noelle"), "sprite_index", spr_noelle_blush)
    cutscene_set_variable(party_get_inst("susie"), "image_speed", 0)
    
    cutscene_sleep(40)
    cutscene_dialogue([
        "{char(noelle, 4)}* Um, thanks Susie!! That felt... refreshing!",
        "{face_ex(27)}* Didn't know you knew any healing spells!!",
        "{char(susie, 53)}* Oh, yeah, I did learn some cool stuff recently. Thanks."
    ],, false)
    cutscene_wait_dialogue_boxes(2)
    
    cutscene_set_variable(party_get_inst("susie"), "sprite_index", spr_susie_walk_back_arm)
    cutscene_set_variable(party_get_inst("susie"), "image_speed", 0)
    cutscene_wait_dialogue_finish()
    
    cutscene_set_variable(party_get_inst("susie"), "image_xscale", 1)
    cutscene_set_variable(party_get_inst("susie"), "s_override", false)
    
    cutscene_set_variable(party_get_inst("noelle"), "s_override", false)
    
    cutscene_party_follow(true)
    cutscene_party_interpolate()
    cutscene_player_canmove(true)
    cutscene_play()
}