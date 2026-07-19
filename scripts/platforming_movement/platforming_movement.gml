global.platforming_perspective = 0
global.allow_use_platswap_statue = true

function player_platforming_movement_init(){
	if !instance_exists(o_ow_plat_statue) or !instance_exists(o_ow_plat_ground) {global.platforming_perspective=0}
	
	pf_enabled = global.platforming_perspective ? 1 : 0
	pf_caterrecordtime = 0

	pf_collide = []
	
	pf_hmove = 0
	pf_air_accel = 2
	pf_air_decel = 0.5
	pf_ground_accel = 2
	pf_ground_decel = 0.65
	pf_hmovemax = 4.5
	pf_keyLeft = 0
	pf_keyRight = 0

	pf_dir = DIR.LEFT
    
    pf_xscale_prev = image_xscale;
    pf_turn_timer = 0;
	
	pf__gravity = 1.25/2;
	pf__canjump = true;
	pf__infinitejumps = false; //u
	pf__jumpheight = 7;
	pf__airmintime = 4;
	pf__coyotetimemax = 4;
	pf__squattimemax = 2;

	pf_currentgravity = pf__gravity;
	pf_vspeed = 0;
	pf_jump_key_held_time = 0;
	pf_jumpstage = 0;
	pf_airtime = 0;
	pf_cotoyetime = 0;
	pf_squattime = 0;
	pf_jumpbuffer = 0;
	pf_final_xchange = 0;
	pf_final_ychange = 0;
    pf_land = 0;
    pf_grounded = true;
	
	pf_attacking = false; //u
    pf_attack_timer = 0; //u
    pf_attack_length = 20; //u
	pf_hurt = false //u
	pf_hitstop = 0; //u
}

function temp_player_platforming_movement_execute(){
	{
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
	}}
	var grounded = place_meeting(x, y+1, pf_collide);
	var ceilded = place_meeting(x, y-4, pf_collide);
    var _turn_sprite = false;
	
	pf_hmove = (InputCheck(INPUT_VERB.RIGHT)-InputCheck(INPUT_VERB.LEFT))*4
	

	
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
	
	// Platforming Horizontal Movement ---------
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
	   or pf_hurt //or pf_jumpstage == 3 
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
	/*if pf_jumpstage == 3 
        _hdecel = 1;*/
	
	if !_dont_accel{
		if pf_keyLeft {
			if grounded and keyPressLeft
                instance_create(o_eff_generic_animation, x + 16, y, depth, {sprite_index: spr_eff_plat_land_dust, image_xscale: -1});
            
			var last_hspeed = pf_hmove;
			pf_hmove -= _haccel;
            
			//if run_zone {_hspeedmin = -(dashspeed_modified+4)}
            
			if last_hspeed <=_hspeedmin
                pf_hmove = clamp(pf_hmove*_hdecel, last_hspeed, _hspeedmin);
		}
		if pf_keyRight {
			if grounded and keyPressRight 
                instance_create(o_eff_generic_animation, x - 16, y, depth, {sprite_index: spr_eff_plat_land_dust, image_xscale: 1});
            
			var last_hspeed = pf_hmove;
			pf_hmove += _haccel;
            
			//if run_zone {_hspeedmax = dashspeed_modified-4}
            
			if last_hspeed >=_hspeedmax
                pf_hmove = clamp(pf_hmove*_hdecel, _hspeedmax, last_hspeed);
		}
	}
	
	if ((!pf_keyLeft and !pf_keyRight) or (pf_keyLeft and pf_keyRight) or force_decel) 
        pf_hmove *= _hdecel;
	
	// Platforming Jumping Vertical Movement --------
	var keyIsInvertJumpAndAttack = false
	var keyJump = keyIsInvertJumpAndAttack ? InputCheck(INPUT_VERB.SELECT) : InputCheck(INPUT_VERB.CANCEL)
	var keyJumpPressed = keyIsInvertJumpAndAttack ? InputPressed(INPUT_VERB.SELECT) : InputPressed(INPUT_VERB.CANCEL)
	var keyAttack = keyIsInvertJumpAndAttack ? InputCheck(INPUT_VERB.CANCEL) : InputCheck(INPUT_VERB.SELECT)
	var keyAttackPressed = keyIsInvertJumpAndAttack ? InputPressed(INPUT_VERB.CANCEL) : InputPressed(INPUT_VERB.SELECT)
	
	if !pf__canjump {
        keyJump = 0; 
        keyJumpPressed = 0;
    }
	
	if keyJumpPressed
        pf_jumpbuffer = 4;
    else 
        pf_jumpbuffer = max(pf_jumpbuffer - 1, 0);
	
	if grounded {
		if pf_airtime != 0 {
            if pf_hmove == 0  // land animation
                audio_play(snd_noise, , , 1.2);
            
            pf_land = 4;
            
            instance_create(o_eff_generic_animation, x - 16, y, depth, {sprite_index: spr_eff_plat_land_dust, image_xscale: 1});
            instance_create(o_eff_generic_animation, x + 16, y, depth, {sprite_index: spr_eff_plat_land_dust, image_xscale: -1});
        }
		
		pf_jumpstage = 0;
		pf_vspeed = 0;
		pf_airtime = 0;
		pf_cotoyetime = pf__coyotetimemax;
	}
	else{
		pf_airtime++;
		if pf_jumpstage == 0
			pf_jumpstage = 2;
	}
	
	var release_jump = false;
	
	if ceilded or (!keyJump and pf_airtime >= pf__coyotetimemax) {
        release_jump = true; 
        pf_airtime = max(pf_airtime, pf__coyotetimemax + 1);
    }
	
	if !pf_jumpbuffer and pf_squattime <= 0 and (!grounded and pf_cotoyetime > 0) 
        pf_cotoyetime --;
		
	if keyJump {
		pf_jump_key_held_time ++;
		if pf_jump_key_held_time < 4 and (grounded or (pf_cotoyetime > 0 and pf_vspeed > -1)) /*and !pf_attacking and !pf_hurt*/ {
		    var inc = 1;
		    pf_squattime = max(pf_squattime + inc, 1);
		    pf_jumpbuffer = 0;
        
			if pf_squattime > pf__squattimemax {
				pf_squattime = 0;
				pf_cotoyetime = 0;
            
				if !ceilded {
	                y -= 1; 
	                pf_vspeed = -pf__jumpheight; 
	                pf_jumpstage = 1; 
	                audio_play(snd_ui_cancel_small, , , 1.5);
	            }
			}
		}
		else {
	        pf_squattime = 0;
		}
	}
	else {
		pf_jump_key_held_time = 0;
		if (pf_jumpstage == 1 and pf_airtime > pf__airmintime) {
			release_jump = true;
			pf_jumpstage = 2;
		}
	}
    
	if (pf_vspeed < 0 or pf_hitstop > 0) and release_jump /*and !pf_hurt*/{
		pf_vspeed *= 0.5;
	}
	
	if array_contains([1, 2], pf_jumpstage) and !grounded and pf_airtime > pf__airmintime {
		pf_vspeed += pf_currentgravity
	}
	
	// Platforming Finish Movement -----
	pf_final_xchange = pf_hmove
	pf_final_ychange = pf_vspeed
	move_and_collide_simpler(pf_final_xchange, pf_final_ychange, pf_collide)
	
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
	if pf_hmove != 0 or pf_final_ychange != 0 or !grounded {
        moving = true;
    }	
    
    pf_grounded = grounded;
    actor_platforming_animate(pf_grounded, pf_final_xchange, pf_final_ychange, pf_dir);
}

function actor_platforming_animate(_grounded, _dx, _dy, _dir) {
    var turn_anim_len = 6;
    
    image_xscale = (_dir == DIR.RIGHT ? 1 : -1);
    image_speed = 1;
    
    if pf_xscale_prev != image_xscale && pf_turn_timer == 0
        pf_turn_timer = turn_anim_len;
    
	if pf_airtime <= 1 and pf_jumpstage == 1{
        sprite_index = s_plat_land;
        image_index = 0;
	}
    else if !_grounded {
        if _dy < 0
            sprite_index = s_plat_jump_up;
        else if _dy >= 0 
            sprite_index = s_plat_jump_down;
    }
    else if pf_land > 0 {
        sprite_index = s_plat_land;
        image_index = (image_number - 1) * pf_land/8;
    }
    else if _dx != 0 {
        if pf_turn_timer > 0 {
            sprite_index = s_plat_turn;
            image_index = (1 - pf_turn_timer/turn_anim_len) * (sprite_get_number(s_plat_turn) - 1);
            image_speed = 0;
        }
        else
            sprite_index = s_plat_run;
    }
    else if (sprite_index == s_plat_run || sprite_index == s_plat_turn) {
        sprite_index = s_plat_run_stop;
        image_index = 0;
        queued_sprite = s_plat_idle;
    }
    else if sprite_index != s_plat_run_stop
        sprite_index = s_plat_idle;
    
    pf_xscale_prev = image_xscale;
    if pf_turn_timer > 0
        pf_turn_timer --;
}