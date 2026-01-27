event_inherited()

chase_mode = 0

trigger_code = function() {
    if chase_mode == 1 
        return false
    if instance_exists(target_enemy_instance) {
        target_enemy_instance.__start_chasing()
    }
}
trigger_exit_code = function() {
    triggered = false
}