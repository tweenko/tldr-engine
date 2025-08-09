if transition_mode == 0 {
	transition_mode = 1;
} 
else {
	instance_destroy(self);
}

is_transitioning = false;