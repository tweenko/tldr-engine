event_inherited();
buffered = false;
controlled_activation = false;

trigger_code = function() {
    if buffered
        return false;
    
    if o_dev_climb_controller.climbing { // stop climbing
        if !o_dev_climb_controller.leader_in_trans
            climb_stop_nearest();
        else 
            buffered = true;
    }
    else { // start climbing
        if !o_dev_climb_controller.leader_in_trans
            climb_start_nearest();
        else 
            buffered = true;
    }
}
trigger_exit_code = function() {
    if buffered
        buffered = false;
    triggered = false;
}