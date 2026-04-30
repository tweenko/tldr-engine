if seed[step] == "jump" { // jump animation
	if stage == 0 {
		if timer == 0 {
			character.depth_override = -2000 - yreq[step]
			character.s_override = true
			character.moveable_move = false
		}
		if timer >= time[step]
			stage = 1
	}
	else if stage == 1 {
		timer = 0
        
        if play_sfx[step] 
            audio_play(snd_wing,,,, 1)
		var spr = character.s_landed
        
		if sprite_exists(spr) {
            animate(0, 2, 15, anime_curve.linear, character, "image_index")
            
			character.image_speed = 0
			character.sprite_index = spr
		}
		
		stage ++
	}
	else if stage == 2 && timer == 20 { 
		timer = 0
		character.yoff = 0
		character.depth_override = undefined
		step ++
        
        // end prematurely and set direction to down
		if step >= array_length(xreq) || step >= array_length(yreq) {
			character.dir = DIR.DOWN
			instance_destroy()
		}
		else {
            step --;
			event_user(0)
			exit
		}
	}
	
	timer ++
}
else if seed[step] == "jump_into" { // jump animation (without landing)
	if stage == 0 {
		if timer == 0 {
			character.depth_override = -2000 - yreq[step];
			character.s_override = true;
			character.moveable_move = false;
		}
		if timer >= time[step]
			stage = 1;
	}
	else if stage == 1 {
		timer = 0;
		character.yoff = 0;
		character.depth_override = undefined;
        
        if play_sfx[step] 
            audio_play(snd_wing,,,, 1);
        
        event_user(0);
        exit;
	}
	
	timer ++
}
else { // walk over
	if stage == 0 {
		anims = []
		character.moveable_move = false
        
		var a = point_direction(0, 0, xdiff, ydiff)
		character.dir = actor_angletodir(a)
		if char_dir[step] != undefined
			character.dir = char_dir[step]
		
		character.image_index = 0
		character.image_speed = max(.5, spd[step] / 4)
		character.sprite_index = character.s_move[character.dir]
		character.s_override = true
		
		if xdiff != 0 
			array_push(anims, animate(character.x, character.x + xdiff, time[step], "linear", character, "x"))
		if ydiff != 0 
			array_push(anims, animate(character.y, character.y + ydiff, time[step], "linear", character, "y"))
		
		stage = 1
	}  
	if stage == 1 {
		if timer >= time[step] {
			timer = 0
			stage = 2
			character.x = xreq[step]
			character.y = yreq[step]
		}
	}
	if stage == 2 {
		timer = 0
		event_user(0)
	}
	
	timer ++
}