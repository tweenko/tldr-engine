if !instance_exists(get_leader())
    instance_destroy();

if climbing {
    leader_grounded = false;
    
    if !leader_climbing {
        get_leader().moveable_climbing = false;
        get_leader().sprite_index = get_leader().s_climb;
        
        leader_climbing = true;
    }
    else if !leader_in_trans {
        if leader_attached {
            if move_buffer <= 0 && jump_buffer <= 0 && bump_timer <= 0 && get_leader()._checkmove() {
                var x_move = InputX(INPUT_CLUSTER.NAVIGATION);
                var y_move = InputY(INPUT_CLUSTER.NAVIGATION);
                
                if x_move != 0 || y_move != 0 {
                    var ___reach = InputCheck(INPUT_VERB.SELECT) ? jump_reach_max + 10 : move_reach;
						  var ___jm = InputCheck(INPUT_VERB.SELECT) ? CLIMB_JUMP_MODE.FURTHEREST : CLIMB_JUMP_MODE.NEAREST;
                    if InputCheck(INPUT_VERB.RIGHT) and InputCheck(INPUT_VERB.UP) {
                    	if !__find_tile(___reach, 0, ___jm) and __find_tile(___reach, 90, ___jm) current_direction = 90;
                    	else if __find_tile(___reach, 0, ___jm) and !__find_tile(___reach, 90, ___jm) current_direction = 0;
                    	else if last_direction == 0 current_direction = 90 else current_direction = 0;
                    }
                    else if InputCheck(INPUT_VERB.LEFT) and InputCheck(INPUT_VERB.UP) {
                    	if !__find_tile(___reach, 180, ___jm) and __find_tile(___reach, 90, ___jm) current_direction = 90;
                    	else if __find_tile(___reach, 180, ___jm) and !__find_tile(___reach, 90, ___jm) current_direction = 180;
                    	else if last_direction == 180 current_direction = 90 else current_direction = 180;
                    }
                    else if InputCheck(INPUT_VERB.RIGHT) and InputCheck(INPUT_VERB.DOWN) {
                    	if !__find_tile(___reach, 0, ___jm) and __find_tile(___reach, 270, ___jm) current_direction = 270;
                    	else if __find_tile(___reach, 0, ___jm) and !__find_tile(___reach, 270, ___jm) current_direction = 0;
                    	else if last_direction == 0 current_direction = 270 else current_direction = 0;
                    }
                    else if InputCheck(INPUT_VERB.LEFT) and InputCheck(INPUT_VERB.DOWN) {
                    	if !__find_tile(___reach, 180, ___jm) and __find_tile(___reach, 270, ___jm) current_direction = 270;
                    	else if __find_tile(___reach, 180, ___jm) and !__find_tile(___reach, 270, ___jm) current_direction = 180;
                    	else if last_direction == 180 current_direction = 270 else current_direction = 180;
                    }
                    else current_direction = snap(InputDirection(90, INPUT_CLUSTER.NAVIGATION), 90);
                }
                
                // charge
                if (InputCheck(INPUT_VERB.SELECT) && !InputCheck(INPUT_VERB.CANCEL) && jump_buffer <= 0 && !jump_canceled) || jump_timer > 0 {
                    var target_tile = __find_tile(jump_reach + 10, current_direction, CLIMB_JUMP_MODE.FURTHEREST);
                    jump_target_tile = target_tile;
                    
                    if jump_timer == 0 { // init
                        jump_timer = 0;
                        sfx_charge = audio_play(snd_chargeshot_charge, true, .3, .4);
                    }
                    
                    // cap the jump reach
                    if jump_reach < jump_reach_max
                        jump_reach += 2;
                    else 
                        jump_reach = jump_reach_max;
                    
                    // charge sprites
                    var charge_sprite = get_leader().s_climb_charge;
                    switch current_direction {
                        case 0:
                            charge_sprite = get_leader().s_climb_charge_right;
                            break;
                        case 180:
                            charge_sprite = get_leader().s_climb_charge_left;
                            break;
                    }
                    // animate them
                    get_leader().sprite_index = charge_sprite;
						  if jump_reach/clamp(jump_reach_max, 0, 50) > 2/3
						      get_leader().image_index = 2;
						  else if jump_reach/clamp(jump_reach_max, 0, 50) > 1/3
						      get_leader().image_index = 1;
                    else
						      get_leader().image_index = 0;
                    
                    // player charge indicator
                    if jump_reach/clamp(jump_reach_max, 0, 50) > 2/3 {
                        get_leader().override_blend = merge_color(get_leader().image_blend, c_teal, 0.4 + floor(sin(jump_timer)) * .4);
                        audio_sound_pitch(sfx_charge, .7);
                        
                        if jump_timer % 5 == 0 {
                            with get_leader() {
                                var inst = afterimage(.2);
                                inst.scale_mod = .05;
                            }
                        }
                    }
                    else if jump_reach/clamp(jump_reach_max, 0, 50) > 1/3 {
                        get_leader().override_blend = merge_color(get_leader().image_blend, c_teal, 0.2 + floor(sin(jump_timer)) * .2);
                        audio_sound_pitch(sfx_charge, .5);
                    }
                    else 
                        get_leader().override_blend = undefined;
                    
                    jump_timer ++;
                    
                     // select is let go
                    if !InputCheck(INPUT_VERB.SELECT) {
                        if instance_exists(target_tile) {
                            move_buffer = 10;
                            jump_buffer = 15;
                            jump_target_tile = noone;
                            jump_trail_timer = 10;
                            
                            // spawn particles
                            repeat(5) {
                                instance_create(o_eff_generic, get_leader().x + random_range(-7, 7), get_leader().y + random_range(-7, 7), get_leader().depth + 20, {
                                    sprite_index: spr_eff_climb_dust,
                                    image_speed: 1,
                                    end_alpha: 1,
                                    life: 8,
                                    vspeed: -.25,
                                })
                            }
                            
                            var jump_sprite = get_leader().s_climb_jump_up;
                            switch current_direction {
                                case 0:
                                    jump_sprite = get_leader().s_climb_jump_right;
                                    break;
                                case 180:
                                    jump_sprite = get_leader().s_climb_jump_left;
                                    break;
                            }
                            get_leader().sprite_index = jump_sprite;
                            get_leader().image_index = 0;
                            get_leader().image_speed = 1;
                            
                            audio_stop_sound(snd_wing);
                            audio_play(snd_wing, false, .7, .6 + random(.3));
                            
                            animate(get_leader().x, target_tile.x, 10, anime_curve.sine_out, get_leader(), "x");
                            animate(get_leader().y, target_tile.y + 2, 10, anime_curve.sine_out, get_leader(), "y");
                            
                            // change to land sprite
                            __queue_call(4, method(self, function() {
                                switch current_direction {
                                    case 0:
                                        get_leader().sprite_index = get_leader().s_climb_land_right;
                                        break;
                                    case 180:
                                        get_leader().sprite_index = get_leader().s_climb_land_left;
                                        break;
                                }
                            }));
                            
                            // change to climb sprite upon fully landing
                            __queue_call(10, method(get_leader(), function() {
                                get_leader().sprite_index = get_leader().s_climb;
                                get_leader().image_index = 0;
                                get_leader().image_speed = 0;
                            }));
                        }
                        else {
                            bump_timer = bump_off_time;
                            bump_buffered_movement = undefined;
                            
									 last_direction = current_direction;
                            if current_direction % 180 == 0
                                last_horizontal_direction = current_direction;
                            if current_direction % 180 == 90
                                last_vertical_direction = current_direction;
                            
                            get_leader().sprite_index = get_leader().s_climb_charge_left;
                            if last_horizontal_direction == 0
                                get_leader().sprite_index = get_leader().s_climb_charge_right;
                            
                            audio_play(snd_bump);
                        }
                        
                        get_leader().override_blend = undefined;
                        if audio_is_playing(sfx_charge)
                            audio_stop_sound(sfx_charge);
                        
                        jump_reach = 5;
                        jump_timer = 0;
                        jump_target_tile = noone;
                    }
                }
                // move
                else if (x_move != 0 || y_move != 0) || !is_undefined(bump_buffered_movement) {
                    // unbuffer the bump movement
                    if x_move == 0 && y_move == 0 && !is_undefined(bump_buffered_movement) {
                        current_direction = bump_buffered_movement;
                        bump_buffered_movement = undefined;
                    }
                    
                    var target_tile = __find_tile(move_reach, current_direction);
                    if instance_exists(target_tile) {
                        move_buffer = 10;
                        jump_buffer = 0;
                        
								last_direction = current_direction;
                        if current_direction % 180 == 0
                           last_horizontal_direction = current_direction;
                        if current_direction % 180 == 90
                           last_vertical_direction = current_direction;
                        
                        animate(get_leader().x, target_tile.x, 8, anime_curve.sine_out, get_leader(), "x");
                        animate(get_leader().y, target_tile.y + 2, 8, anime_curve.sine_out, get_leader(), "y");
                        
                        audio_play(snd_wing, false, 0.6, 1.1 + random(.1));
                        
                        get_leader().sprite_index = get_leader().s_climb;
                        get_leader().image_speed = 0;
                        get_leader().image_index = cap_wraparound(get_leader().image_index + 1, get_leader().image_number);
                        __queue_call(8, method(get_leader(), function() {
                            image_index = cap_wraparound(image_index + 1, image_number);
                        }));
                    }
                    else {
                        bump_timer = bump_off_time;
                        bump_buffered_movement = undefined;
                        
								
								last_direction = current_direction;
                        if current_direction % 180 == 0
                           last_horizontal_direction = current_direction;
                        if current_direction % 180 == 90
                           last_vertical_direction = current_direction;
                        
                        get_leader().sprite_index = get_leader().s_climb_charge_left;
                        if last_horizontal_direction == 0
                            get_leader().sprite_index = get_leader().s_climb_charge_right;
                        
                        var inst_return = noone;
                        with get_leader()
                            inst_return = instance_place(x, y, o_dev_climb_auto);
                        
                        if instance_exists(inst_return) 
                            inst_return.trigger_exit_code();
                        else 
                            audio_play(snd_bump);
                    }
                    
                    jump_reach = 0;
                    jump_target_tile = noone;
                    jump_timer = 0;
                }
                else {
                    jump_reach = 0;
                    jump_target_tile = noone;
                    jump_timer = 0;
                    
                    get_leader().sprite_index = get_leader().s_climb;
                }
                
                // cancel
                if InputPressed(INPUT_VERB.CANCEL) && jump_timer > 0 {
                    get_leader().override_blend = undefined;
                    
                    get_leader().sprite_index = get_leader().s_climb;
                    get_leader().image_index = 0;
                    
                    if audio_is_playing(sfx_charge)
                        audio_stop_sound(sfx_charge);
                    
                    jump_reach = 5;
                    jump_timer = 0;
                    jump_target_tile = noone;
                    jump_canceled = true;
                }
            }
            
            // account for inputs during bump buffer
            if bump_timer > 0 {
                var x_move = InputX(INPUT_CLUSTER.NAVIGATION);
                var y_move = InputY(INPUT_CLUSTER.NAVIGATION);
                if x_move != 0 || y_move != 0
                    bump_buffered_movement = snap(InputDirection(90, INPUT_CLUSTER.NAVIGATION), 90);
                
                // don't buffer same direction
                if bump_buffered_movement == current_direction
                    bump_buffered_movement = undefined;
                
                bump_timer --;
                
                // return to default climbing sprite
                if bump_timer == 0 
                    get_leader().sprite_index = get_leader().s_climb;
            }
            
            leader_spd_y = 0;
        }
        else {
            get_leader().sprite_index = get_leader().s_climb_slip_fall;
            
            if leader_grab_when_falling {
                var target_tile = __find_tile(leader_spd_y, 270, CLIMB_JUMP_MODE.NEAREST);
                if instance_exists(target_tile) {
                    leader_attached = true;
                    get_leader().x = target_tile.x;
                    get_leader().y = target_tile.y + 2;
                    get_leader().sprite_index = get_leader().s_climb;
                    get_leader().image_index = 0;
                    
                    audio_play(snd_noise);
                }
            }
            
            if !leader_attached {
                if leader_spd_y < leader_terminal_velocity 
                    leader_spd_y += leader_gravity;
                else if leader_spd_y > leader_terminal_velocity
                    leader_spd_y = leader_terminal_velocity;
                
                get_leader().y += leader_spd_y;
            }
        };
        
        if leader_inv <= 0 {
            with get_leader() {
                alpha_mod = 1;
                
                var bullet = instance_place(x, y, o_dodge_bullet);
                if instance_exists(bullet) {
                    with bullet 
                        event_user(1);
                    other.bump_timer = 10;
                }
            }
        }
        else {
            get_leader().alpha_mod = .5;
        }
        
        if leader_inv > 0
            leader_inv --;
        if jump_canceled && !InputCheck(INPUT_VERB.SELECT)
            jump_canceled = false;
        if move_buffer > 0 
            move_buffer --;
        if jump_buffer > 0
            jump_buffer --;
        if jump_trail_timer > 0 {
            if jump_trail_timer % 2 == 0
                with get_leader() {
                    var inst = afterimage(.05);
                    inst.image_alpha = .5;
                    inst.depth = depth + 40;
                }
            jump_trail_timer --;
        }
    }
}
else {
    leader_climbing = false;
    if !leader_in_trans && !leader_grounded
        leader_grounded = true;
}

depth = get_leader().depth - 100;