if alpha <= 0 || ripple_power <= 0 || timer > 240 {
	instance_destroy();
	exit;
}
if timer % choppiness_div == 0 {
	if ripple_power >= 0
		ripple_power -= fade_speed * choppiness_div * 2;
	else
		ripple_power = 0;
	
	if alpha > 0
		alpha -= fade_speed * choppiness_div;
	
	size += ripple_power * choppiness_div;
}

if instance_exists(stick_to_inst) {
	x = stick_to_inst.x + stick_xoff;
	y = stick_to_inst.y + stick_yoff;
}

timer ++;