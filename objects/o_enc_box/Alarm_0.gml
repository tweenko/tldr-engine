if transition_mode == 0 {
	do_anime(0, 1, 15, "linear", function(v) {
		if instance_exists(id) 
			id.temp_scale = v
		}
	)
	do_anime(-180, 0, 15, "linear", function(v) {
		if instance_exists(id) 
			id.temp_angle = v
		}
	)
} 
else {
	do_animate(1, 0, 15, "linear", id, "temp_scale")
	do_animate(0, 180, 15, "linear", id, "temp_angle")
}
trans_frame = 0;
is_transitioning = true;
if sprite == -1
	is_sprite = true;
	
alarm[1] = 15;