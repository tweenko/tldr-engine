if color == 0{
	if is_transitioning == false {
		// Movement
		if InputCheck(INPUT_VERB.CANCEL) 
			movespd = 1;
		else
			movespd = 2;
		
		if InputCheck(INPUT_VERB.LEFT) 
			x -= movespd
		else if InputCheck(INPUT_VERB.RIGHT) 
			x += movespd
		if InputCheck(INPUT_VERB.UP) 
			y -= movespd
		else if InputCheck(INPUT_VERB.DOWN) 
			y += movespd
		
		if (InputCheck(INPUT_VERB.LEFT) 
            || InputCheck(INPUT_VERB.UP) 
            || InputCheck(INPUT_VERB.RIGHT) 
            || InputCheck(INPUT_VERB.DOWN)) 
		&& (x != xprevious || y != yprevious) {
			moving=true
		}
		else 
			moving=false
	
		// "Collisions"
		if instance_exists(o_enc_box) {
			x = clamp(x, o_enc_box.x + 6 - o_enc_box.width/2, o_enc_box.x - 6 + o_enc_box.width/2);
			y = clamp(y, o_enc_box.y + 6.5-o_enc_box.height/2, o_enc_box.y - 5.5 + o_enc_box.height/2);
		}
		if place_meeting(x, y, o_enc_bullet) {
			with instance_place(x, y, o_enc_bullet){
				event_user(0);
			}
		}
		
		if i_frames > 0 {
			i_frames --;
			image_speed = .25;
		} 
		else {
			image_speed = 0;
			image_index = 0;
			i_frames = 0;
		}
	}

	mygraze.x = self.x;
	mygraze.y = self.y;
	mygraze.can_graze = (i_frames == 0);
}