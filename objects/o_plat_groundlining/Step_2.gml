if maker.pulpit==true{
	if place_meeting(x, y, get_leader()) or get_leader().pf_jump_smoothed_final_y_change<0
		{collide = false}
	else
		{collide = true}
}