if play {
	event_user(0)
	if ds_queue_empty(actions)
		instance_destroy()
	
	if sleep > 0
		sleep --
	if sleep == -1 {
		if method_call(continue_func, continue_args)
			sleep = 0
	}
}