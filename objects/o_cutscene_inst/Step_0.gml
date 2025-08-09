if play {
	while sleep == 0 {
		if ds_queue_empty(actions)
			exit
		
		var args = ds_queue_dequeue(actions)
		script_execute_ext(args[0], args, 1)
	}
	if ds_queue_empty(actions)
		instance_destroy()
	
	if sleep > 0
		sleep --
	if sleep == -1 {
		if script_execute_ext(continue_func, continue_args)
			sleep = 0
	}
}