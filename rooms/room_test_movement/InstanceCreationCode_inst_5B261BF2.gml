trigger_code = function() {
    for (var i = 1; i < array_length(global.party_names); i ++) {
        var marker = marker_getpos("test_pm_wait", i)
        
        if !is_undefined(marker) {
            actor_move(party_get_inst(global.party_names[i]), new actor_movement(marker.x, marker.y, 15,,, DIR.RIGHT), i)
            party_get_inst(global.party_names[i]).follow = false
        }
    }
    
    o_camera.target = noone
    
    camera_stop_animations()
    camera_pan(400 - 160, 120, 10)
}
trigger_exit_code = function() {
    party_setfollow(true)
    
    for (var i = 1; i < array_length(global.party_names); ++i) {
        party_member_interpolate(global.party_names[i])
    }
    
    camera_stop_animations()
    camera_unpan(get_leader(), 10)
    
    triggered = false
}