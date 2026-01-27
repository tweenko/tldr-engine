if color == 0 {
	if is_transitioning == false {
		// Movement
		if InputCheck(INPUT_VERB.CANCEL) 
			real_spd = spd/2;
		else
			real_spd = spd;
		
        var xx = 0
        var yy = 0
        
		if InputCheck(INPUT_VERB.LEFT) 
			xx -= real_spd
		else if InputCheck(INPUT_VERB.RIGHT) 
			xx += real_spd
		if InputCheck(INPUT_VERB.UP) 
			yy -= real_spd
		else if InputCheck(INPUT_VERB.DOWN) 
			yy += real_spd
        
        var xstep = .25 * sign(xx)
        for (var i = 0; i < abs(xx); i ++) { // horizontal collisions
            if !place_meeting(x + xstep + sign(xstep)*1.5, y, o_enc_box_solid)
                x += xstep
        }
        var ystep = .25 * sign(yy)
        for (var i = 0; i < abs(yy); i ++) { // vertical collisions
            if !place_meeting(x, y + ystep + sign(ystep)*1.5, o_enc_box_solid)
                y += ystep
        }
		
		if (InputCheck(INPUT_VERB.LEFT) 
            || InputCheck(INPUT_VERB.UP) 
            || InputCheck(INPUT_VERB.RIGHT) 
            || InputCheck(INPUT_VERB.DOWN)) 
		&& (x != xprevious || y != yprevious) {
			moving = true
		}
		else 
			moving = false
        
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

	inst_graze.x = self.x;
	inst_graze.y = self.y;
	inst_graze.can_graze = (i_frames == 0 && !instance_exists(inst_aura));
}

if instance_exists(inst_aura) {
    inst_aura.x = self.x
    inst_aura.y = self.y
}