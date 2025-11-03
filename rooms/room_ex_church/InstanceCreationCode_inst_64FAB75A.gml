trigger_code = function() {
    o_camera.follow_y = false
    camera_pan(undefined, 186, 40, "sine_out", true)
    
    lighting_on(0xFFD042)
}
trigger_exit_code = function() {
    lighting_off()
    
    o_camera.follow_y = true
    camera_unpan(get_leader(), 40, "cubic_out")
    
    triggered = false
}