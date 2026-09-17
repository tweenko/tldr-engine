var active = place_meeting(x, y, o_actor);

if active
	image_alpha = lerp(image_alpha, 1, .125);
else
	image_alpha = lerp(image_alpha, -0.125, 0.05);