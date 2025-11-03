trigger_code = function() {
    if !party_ismember("susie")
        exit
    
    cutscene_create()
    cutscene_player_canmove(false)
    cutscene_party_follow(false)
    cutscene_set_variable(o_camera, "target", noone)
    cutscene_camera_pan(210, 186, 20, false)
    
    for (var i = 0; i < array_length(global.party_names); i ++) {
        var marker = marker_get("prophecy_pos", global.party_names[i])
        if !instance_exists(marker)
            continue
        
        cutscene_actor_move(party_get_inst(global.party_names[i]), new actor_movement(marker.x, marker.y, 20), i, false)
    }
    cutscene_sleep(20)
    
    for (var i = 0; i < array_length(global.party_names); i ++) {
        cutscene_set_variable(party_get_inst(global.party_names[i]), "dir", DIR.UP)
    }
    cutscene_sleep(30)
    
    cutscene_dialogue(loc("txt_room_example_church_cutscene"),, false, true)
    cutscene_wait_dialogue_boxes(1)
    
    cutscene_set_variable(party_get_inst("susie"), "s_override", true)
    cutscene_set_variable(party_get_inst("susie"), "sprite_index", spr_susie_up_head_down)
    cutscene_wait_dialogue_boxes(2)
    
    cutscene_set_variable(party_get_inst("susie"), "sprite_index", spr_susie_up)
    cutscene_wait_dialogue_boxes(1)
    
    cutscene_set_variable(party_get_inst("susie"), "sprite_index", spr_susie_up_head_down)
    cutscene_wait_dialogue_finish()
    
    cutscene_set_variable(party_get_inst("susie"), "s_override", false)
    cutscene_set_variable(party_get_inst("susie"), "dir", DIR.RIGHT)
    
    cutscene_func(camera_unpan, [get_leader(), 20])
    cutscene_sleep(20)
    
    cutscene_player_canmove(true)
    cutscene_party_follow(true)
    cutscene_party_interpolate()
    cutscene_play()
}