if can_graze == true && o_enc.turn_timer > 10 {
	if graze_buffer > 0
		graze_buffer --;
	else {
		graze_buffer = 0;
		grazed_inst = noone;
	}

	if (graze_buffer == 0 && place_meeting(x, y, grazed_inst))
	|| instance_place(x, y, o_enc_bullet) != grazed_inst {
		if instance_exists(instance_place(x, y, o_enc_bullet)) 
		&& instance_place(x, y, o_enc_bullet).color == BULLET_COLOR.SOLID
		&& instance_place(x, y, o_enc_bullet).graze > 0 {
			grazed_inst = instance_place(x, y, o_enc_bullet);
			event_user(0);
			graze_buffer = 3;
		}
	}
}

if grazed_inst != noone && graze_new_buffer > 0 {
	if image_index < 3 {
		image_index += 0.67;
		image_alpha = 1;
	} 
	else {
		image_index = 3;
		image_alpha = 0;
	}
}
else if grazed_inst != noone && graze_new_buffer <= 0 {
    image_alpha = max(image_alpha, .35);
}

image_alpha -= 0.1;

grazed_previous = grazed_inst;
if graze_new_buffer > 0
    graze_new_buffer --