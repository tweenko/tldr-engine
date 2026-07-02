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
else if follow && is_follower {
	var plat = get_leader().pf_enabled
	
	x = record[0][pos]
	y = record[1][pos]
	
	dir = record[2][pos]
	running = record[3][pos]
	state = record[4][pos]
	sliding = record[5][pos]
	
	if y != get_leader().y && plat
        get_leader().pf_caterrecordtime = 14
	
	if get_leader().moving or get_leader().pf_caterrecordtime > 0 {
		array_insert_cycle(record[0], 0, get_leader().x)
		array_insert_cycle(record[1], 0, get_leader().y)
		array_insert_cycle(record[2], 0, get_leader().dir)
		array_insert_cycle(record[3], 0, get_leader().running)
		array_insert_cycle(record[4], 0, get_leader().state)
		array_insert_cycle(record[5], 0, get_leader().sliding)
	}
}
else if sliding {
	if instance_exists(slideinst) && !place_meeting(x, y, slideinst){
		sliding = false
		y -= global.slide_speed
	}
    
	y += global.slide_speed
}

// just make it known that you are moving (if you are not the player)
var __xdiff = (x - xprevious != 0);
var __ydiff = (y - yprevious != 0) && global.platforming_perspective % 1 == 0;

if !is_player and ((__xdiff || __ydiff) and !is_in_battle and !is_enemy) or sliding {
    moving = true
}
else if moving and ((__xdiff || __ydiff) and !is_in_battle and !is_enemy) {}
else {
    moving = false
}

// something
/*if (!is_in_battle && !is_enemy && !s_override && s_dynamic) {
    if (walkbuffer > 3) {
        walktimer += 1.5;
            
        if (running)
            walktimer += 1.5;
            
        if (walktimer >= 40)
            walktimer = 0;
            
        if (walktimer < 10)
            image_index = 0;
        if (walktimer >= 10)
            image_index = 1;
        if (walktimer >= 20)
            image_index = 2;
        if (walktimer >= 30)
            image_index = 3;
    }
        
    if (walkbuffer <= 0) {
        if (walktimer < 10)
            walktimer = 9.5;
            
            if (walktimer >= 10 && walktimer < 20)
                walktimer = 19.5;
            
            if (walktimer >= 20 && walktimer < 30)
                walktimer = 29.5;
            if (walktimer >= 30)
                walktimer = 39.5;
            
            image_index = 0;
    }
}  */ 

// sprites
if moving && !is_in_battle && !is_enemy && s_dynamic && !s_override {
	if !startedmoving {
		startedmoving = true
        
        last_walk_frame = cap_wraparound(last_walk_frame + 1, image_number);
        last_walk_buffer = 12;
		image_index = last_walk_frame
	}
	if !running
		image_speed = s_walk_ispd
}
else if !is_in_battle && !is_enemy {
	startedmoving = false
	
	if floor(image_index) % 2 == 0 && !s_override && s_dynamic {
		image_speed = 0;
		image_index = 0
	}
}

// running sprites, walking sprites
if !is_in_battle && !is_enemy && s_dynamic && !s_override {
	if running && moving {
		image_speed = lerp(s_walk_ispd, s_run_ispd, (get_leader().spd - basespd) / (4 - basespd))
		sprite_index = asset_get_index(sprite_get_name(s_move[dir]) + s_run_postfix)
	}
	else {
		sprite_index = s_move[dir]
    }
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
