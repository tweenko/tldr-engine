var check_canmove = _checkmove() && !climb_check();
var x_move = 0
var y_move = 0

if is_enemy && freeze > 0 {
    image_speed = 0
    sprite_index = s_hurt
    
    exit
}
if spawn_buffer > 0
    spawn_buffer --

if !init
	exit

// player movement
if is_player && check_canmove {
	event_user(3) // Player interactions event
}

// if i am a follower and i am following the leader
else if follow && is_follower && instance_exists(follow_target) {
	var plat = get_leader().pf_enabled;
    
    __refresh_follow(pos);
	if get_leader().moving or get_leader().pf_caterrecordtime > 0 && global.platforming_perspective == 1 {
		array_insert_cycle(record, 0, __new_record());
	}
    
	if y != get_leader().y && plat
        get_leader().pf_caterrecordtime = 14;
    if !plat 
        get_leader().pf_caterrecordtime = 0;
    
    if plat 
        actor_platforming_animate(pf_grounded, x - xprevious, y - yprevious, dir);
}
else if sliding {
	if instance_exists(slideinst) && !place_meeting(x, y, slideinst){
		sliding = false
		y -= global.slide_speed
	}
    
	y += global.slide_speed
}

// just make it known that you are moving (if you are not the player)
var __xdiff = abs(x - xprevious) > 0;
var __ydiff = abs(y - yprevious) > 0;

if !is_player and ((__xdiff || __ydiff) and !is_in_battle and !is_enemy) or sliding {
    moving = true
}
else if moving and ((__xdiff || __ydiff) and !is_in_battle and !is_enemy) {}
else {
    moving = false
}

// sprites
if moving && !is_in_battle && !is_enemy && s_dynamic && !s_override && !get_leader().pf_enabled {
	if !startedmoving {
		startedmoving = true
        
        last_walk_frame = cap_wraparound(last_walk_frame + 1, image_number);
        last_walk_buffer = 12;
		image_index = last_walk_frame
	}
	if !running
		image_speed = s_walk_ispd
}
else if !is_in_battle && !is_enemy && !get_leader().pf_enabled {
	startedmoving = false
	
	if floor(image_index) % 2 == 0 && !s_override && s_dynamic && s_current_animation != ACTOR_ANIMATIONS.IDLE
		s_current_animation = ACTOR_ANIMATIONS.IDLE;
}

// running sprites, walking sprites
if !is_in_battle && !is_enemy && s_dynamic && !s_override && !get_leader().pf_enabled {
	if running && moving 
        s_current_animation = ACTOR_ANIMATIONS.RUN;
    else if moving
        s_current_animation = ACTOR_ANIMATIONS.WALK;
    
    switch s_current_animation {
        default: // idle
            var possible_idle = s_idle[dir];
            
            if sprite_exists(possible_idle) { // switch to an idle sprite
                sprite_index = possible_idle;
                image_speed = s_idle_ispd;
                
                if s_previous_animation != s_current_animation 
                    image_index = 0;
            }
            else { // using only the walk sprites
                sprite_index = s_move[dir];
                image_speed = 0;
                image_index = 0;
            }
            
            break;
        case ACTOR_ANIMATIONS.WALK:
            sprite_index = s_move[dir];
            image_speed = s_walk_ispd;
            
            break;
        case ACTOR_ANIMATIONS.RUN:
            sprite_index = asset_get_index_state(sprite_get_name(s_move[dir]), s_run_postfix);
            image_speed = s_run_ispd;
            
            break;
    }
}

// darken in certain conditions
if is_follower {
	var plat_should_darken = (global.platforming_perspective > .5 && !(instance_exists(o_enc) || instance_exists(o_enc_anim)));
    darken_plat = increment_towards(darken_plat, (plat_should_darken ? .5 : 0), .05);
}

{ // timers and siners
	if hurt > 0
		hurt --
	
	if run_away && is_enemy && hurt > 0
		sweat = true
	else
		sweat = false
	
	if flashing 
		fsiner ++
    
    if trail {
        var inst = afterimage(.05)
        inst.depth += 10
    }
    
    if last_walk_buffer > 0
        last_walk_buffer --;
    else 
        last_walk_frame = 0;
}
		
// overworld battle
if o_dodge_controller.dodge_mode && is_player {
	if !instance_exists(dodge_mysoul)
		dodge_mysoul = instance_create(o_dodge_soul, x, y - sprite_height/2 + 4, depth, {caller: id})
}
