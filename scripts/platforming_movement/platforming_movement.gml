global.platforming_perspective = 0
global.allow_use_platswap_statue = true

function player_platforming_movement_init(){
	if !instance_exists(o_ow_plat_statue) or !instance_exists(o_ow_plat_ground) {global.platforming_perspective=0}
	
	pf_enabled = global.platforming_perspective ? 1 : 0
	pf_caterrecordtime = 0

	pf_collide = []

	pf_can_jump = true
	pf_jumptime=0
	pf_jumpvmove=0
	pf_jumpsquat=0
	pf_jumpsquatmax=2
	pf_jumpcoyotetime=0
	pf_jumpcoyotetimemax=4
	pf_jumpbuffer=0
	pf_jumping = 0
	pf_jumpheight=9
	pf_jumpvgrav = 1
	pf_jump_key_held_time = 0
	pf_jump_smoothed_final_y_change = 0

	pf_hmove = 0
	pf_air_accel = 2
	pf_air_decel = 0.5
	pf_ground_accel = 2
	pf_ground_decel = 0.65
	pf_hmovemax = 4.5
	pf_keyLeft = 0
	pf_keyRight = 0

	pf_dir = DIR.LEFT
	pf_attacking = false
	pf_hurt = false
    
    pf_land = 0;
    pf_grounded = true;
}

function player_platforming_movement_execute(){
	// Mask
	mask_index = playermask;
	
	// Caterpillar spacing
	pf_caterrecordtime = max(pf_caterrecordtime - 1, 0);
	for (var i = 0; i < party_length(true); ++i) {
		var pinst = party_get_inst(global.party_names[i]);
		pinst.depth = depth + party_get_index(global.party_names[i]);
	}
	
	// Collision array
	pf_collide = [];
	for (var i = 0; i < instance_number(o_ow_plat_ground); ++i) {
		var inst = instance_find(o_ow_plat_ground, i);
		if variable_instance_exists(inst, "collide") and inst.collide
            array_push(pf_collide, inst);
		
	}
	for (var i = 0; i < instance_number(o_ow_plat_groundlining); ++i) {
		var inst = instance_find(o_ow_plat_groundlining, i);
		if variable_instance_exists(inst, "collide") and inst.collide 
            array_push(pf_collide, inst);
	}
	var grounded = place_meeting(x, y+1, pf_collide);
	var ceilded = place_meeting(x, y-4, pf_collide);
    var _turn_sprite = false;
	
	// Platforming Horizontal Movement
	pf_keyLeft = InputCheck(INPUT_VERB.LEFT);
	pf_keyRight = InputCheck(INPUT_VERB.RIGHT);
	var keyPressLeft = InputPressed(INPUT_VERB.LEFT);
	var keyPressRight = InputPressed(INPUT_VERB.RIGHT);
	
	var _hspeedmax = pf_hmovemax;
	var _hspeedmin = -pf_hmovemax;
	
	var _haccel = pf_air_accel;
	if grounded 
        _haccel = pf_ground_accel;
	
	var _dont_accel = false;
	if (pf_keyLeft and instance_place(x - 4 - abs(pf_hmove), y, pf_collide))
	   or (pf_keyRight and instance_place(x + 4 + abs(pf_hmove), y, pf_collide))
	   or pf_hurt or pf_jumping == 3 
    {
        _dont_accel = true
    }
	
	var _hdecel = pf_air_decel;
	if grounded
        _haccel = pf_ground_decel;
	if !grounded and abs(pf_hmove) > pf_hmovemax 
        _hdecel = 1;
    
	if pf_hurt {
        if !grounded 
            _hdecel = 0.99;
        else 
            _hdecel = pf_ground_decel;
    }
	
	var force_decel = false;
	if grounded and pf_attacking or pf_hurt 
        force_decel = true;
	if pf_jumping == 3 
        _hdecel = 1;
	
	if !_dont_accel{
		if pf_keyLeft {
			if grounded and keyPressLeft {}//vfx_dust(1)
            
			var last_hspeed = pf_hmove;
			pf_hmove -= _haccel;
            
			//if run_zone {_hspeedmin = -(dashspeed_modified+4)}
            
			if last_hspeed <=_hspeedmin {
                pf_hmove = clamp(pf_hmove*_hdecel, last_hspeed, _hspeedmin);
            }
		}
		if pf_keyRight {
			if grounded and keyPressRight {}//vfx_dust(-1)
            
			var last_hspeed = pf_hmove;
			pf_hmove += _haccel;
            
			//if run_zone {_hspeedmax = dashspeed_modified-4}
            
			if last_hspeed >=_hspeedmax {
                pf_hmove = clamp(pf_hmove*_hdecel, _hspeedmax, last_hspeed);
            }
		}
	}
	
	if ((!pf_keyLeft and !pf_keyRight) or (pf_keyLeft and pf_keyRight) or force_decel) 
        pf_hmove *= _hdecel;
	
	// Platforming pf_jumping
	var keyIsInvertJumpAndAttack = false
	var keyJump = keyIsInvertJumpAndAttack ? InputCheck(INPUT_VERB.SELECT) : InputCheck(INPUT_VERB.CANCEL)
	var keyJumpPressed = keyIsInvertJumpAndAttack ? InputPressed(INPUT_VERB.SELECT) : InputPressed(INPUT_VERB.CANCEL)
	var keyAttack = keyIsInvertJumpAndAttack ? InputCheck(INPUT_VERB.CANCEL) : InputCheck(INPUT_VERB.SELECT)
	var jumpheight_real = pf_jumpheight;
    
	if !pf_can_jump {
        keyJump = 0; 
        keyJumpPressed = 0;
    }
    
	if keyJumpPressed
        pf_jumpbuffer = 4;
    else 
        pf_jumpbuffer = max(pf_jumpbuffer - 1, 0);
    
	if grounded {
        // play landing noise if we landed
		if pf_jumptime != 0 and pf_hmove == 0 {
            audio_play(snd_noise, , , 1.2);
            pf_land = 8;
        }
        
        // reset variables upon landing
		pf_jumpcoyotetime = pf_jumpcoyotetimemax;
		pf_jumping = 0;
		pf_jumptime = 0;
		pf_jumpvmove = 0;
		pf_jumpvgrav = 0;
	}
    
	var release_jump = false;
	if ceilded or (!keyJump and pf_jumptime >= pf_jumpcoyotetimemax) {
        release_jump = true; 
        pf_jumptime = max(pf_jumptime, pf_jumpcoyotetimemax + 1);
    }
	if keyJump 
        pf_jump_key_held_time ++;
    else
        pf_jump_key_held_time = 0;
    
	if !grounded 
        pf_jumpvgrav += 1.2/2;
    
	if !pf_jumpbuffer and pf_jumpsquat <= 0 and (!grounded and pf_jumpcoyotetime > 0) 
        pf_jumpcoyotetime --;
    
	if keyJump and pf_jump_key_held_time < 4 and (grounded or (pf_jumpcoyotetime > 0 and pf_jumpvmove > -1)) and !pf_attacking and !pf_hurt {
	    var inc = 1;
	    pf_jumpsquat = max(pf_jumpsquat+inc, 1);
	    pf_jumpbuffer = 0;
        
		if pf_jumpsquat > pf_jumpsquatmax{
			pf_jumpsquat = 0;
			pf_jumpcoyotetime = 0;
            
			if !ceilded {
                y -= 1; 
                pf_jumpvmove = -jumpheight_real; 
                pf_jumping = 1; 
                audio_play(snd_ui_cancel_small, , , 1.5);
            };
		}
	}
	else
        pf_jumpsquat = 0;
    
	if pf_jumping == 1 and pf_jumpvmove > 0 
        pf_jumping = 2;
	if pf_jumping 
        pf_jumptime ++;
    
	if pf_jumpvmove < 0 and release_jump 
        pf_jumpvmove *= 0.75;
    
	var final_y_change = clamp(pf_jumpvmove + pf_jumpvgrav, -jumpheight_real, jumpheight_real);
	pf_jump_smoothed_final_y_change = final_y_change<0 ? final_y_change : increment_towards(pf_jump_smoothed_final_y_change, final_y_change, 1.25);
	
	// Move
	move_and_collide_simpler(pf_hmove, pf_jump_smoothed_final_y_change, pf_collide);
	
	// Ground fix
	var inst = instance_place(x, y + 1, pf_collide);
	if instance_exists(inst) and instance_position(inst.bbox_left+1, inst.bbox_top, inst) and instance_position(inst.bbox_right-1, inst.bbox_top, inst) {
		y = instance_place(x, y + 1, pf_collide).bbox_top;
	}
	
	// ...
	if !pf_keyLeft and !pf_keyRight and pf_hmove != 0 
        pf_hmove = 0
	
	// Direction
	if pf_hmove == 0 {
		if InputCheck(INPUT_VERB.UP) 
            dir = DIR.UP;
		if InputCheck(INPUT_VERB.DOWN) 
            dir = DIR.DOWN;
	}
	if pf_hmove < 0 {
        pf_dir = DIR.LEFT; 
        dir = pf_dir;
    }
	if pf_hmove > 0 {
        pf_dir = DIR.RIGHT; 
        dir = pf_dir;
    }
    
    if pf_land > 0
        pf_land --;
	
	// Set moving
	if pf_hmove != 0 or pf_jump_smoothed_final_y_change != 0 or !grounded {
        moving = true;
    }	
    
    pf_grounded = grounded;
    actor_platforming_animate(pf_grounded, pf_hmove, pf_jump_smoothed_final_y_change, pf_dir);
}

function actor_platforming_animate(_grounded, _dx, _dy, _dir) {
    image_xscale = (_dir == DIR.RIGHT ? 1 : -1);
    image_speed = 1;
    
    if !_grounded {
        if _dy < 0
            sprite_index = s_plat_jump_up;
        else if _dy >= 0 
            sprite_index = s_plat_jump_down;
    }
    else if _dx != 0 
        sprite_index = s_plat_run;
    else if pf_land > 0 {
        sprite_index = s_plat_land;
        image_index = image_number - pf_land/4;
    }
    else if sprite_index == s_plat_run {
        sprite_index = s_plat_run_stop;
        image_index = 0;
        queued_sprite = s_plat_idle;
    }
    else if sprite_index != s_plat_run_stop
        sprite_index = s_plat_idle;
}