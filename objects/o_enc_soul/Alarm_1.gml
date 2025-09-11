/// @desc
if transition_mode == 0 {
	is_transitioning = false;
} 
else {
	is_transitioning = false;
	instance_destroy(inst_graze);
	instance_destroy();
}

transition_mode = 1;