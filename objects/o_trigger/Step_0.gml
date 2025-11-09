if place_meeting(x, y, get_leader()) {
	if !triggered && !controlled_activation
		event_user(0)
    if !triggered && controlled_activation && instance_exists(get_leader()) && get_leader()._checkmove()
        event_user(0)
    
    if triggered
        trigger_step_code()
}
else if trigger_exit {
	event_user(1)
}