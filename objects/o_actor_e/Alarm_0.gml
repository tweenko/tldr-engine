event_inherited()
event_user(3)

if path_exists(idle_path) {
    var xx = x
    var yy = y
    
    path_start(idle_path, idle_path_spd, path_action_continue, true)
    
    if idle_path_autopos {
        var __record_dist = infinity
        var __pos_record = 0
        
        for (var i = 0; i <= 1; i += .025) {
            var cur_dist = point_distance(xx, yy, path_get_x(idle_path, i), path_get_y(idle_path, i))
            if cur_dist < __record_dist {
                __record_dist = cur_dist
                __pos_record = i
            }
            if cur_dist < 5
                break
        }
        
        path_position = __pos_record
    }
    else 
        path_position = idle_path_manualpos_optional
}