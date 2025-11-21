buff = 0 // 0 for default difficulty
debuff = 0 // 0 for default difficulty

am_support = false // destroy if no other turn instances detected

enemy_index = 0
enemy_struct = {}
enemy_base_spr = 0

timer = 0
timer_end = 60 // set to undefined for it to not end automatically
turn_started = false
shorten_by_tension = true

alarm[0] = 1

// destroy to end turn

// for more info how to use support enemies check o_turn_default_dark
__support_init_default = function() {
    for (var i = 0; i < array_length(o_enc.turn_objects); i ++) {
        if instance_exists(o_enc.turn_objects[i]) && o_enc.turn_objects[i].id != id {
            am_support = true
            break
        }
    }
}
__support_destroy_check = function() {
    var end_turn = true
    
    if !am_support
        end_turn = false
    else {
        for (var i = 0; i < array_length(o_enc.turn_objects); i ++) {
            if instance_exists(o_enc.turn_objects[i]) && o_enc.turn_objects[i].id != id {
                show_debug_message($"({id}) found instance: {object_get_name(o_enc.turn_objects[i].object_index)} ({o_enc.turn_objects[i]})")
                end_turn = false
                break
            }
        }
    }
    
    if end_turn
        instance_destroy()
}