if turn_started
	timer ++

if !is_undefined(timer_end) && timer > timer_end
    instance_destroy()