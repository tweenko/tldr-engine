var currentspd = spd
var check_canmove = _checkmove()

if is_enemy && freeze > 0 {
    image_speed = 0
    sprite_index = s_hurt
    
    exit
}
if spawn_buffer > 0
    spawn_buffer --

if !init {
	exit
}

// player movement
if is_player && check_canmove {
	var am_moving = 0
	
	// movement speed control
	if ((!auto_run && InputCheck(INPUT_VERB.CANCEL)) || (auto_run && !InputCheck(INPUT_VERB.CANCEL))) && moving {
		running = true
		
		if spd < runspd // accelerate
			spd += .2
	}
	else {
		running = false
		spd = basespd // instantly return to base speed
	}
	
	// move upon pressing keys
	if InputCheck(INPUT_VERB.RIGHT) {
		if !diagonal 
			for(var i = 0; i < 360; i += 90) if i != DIR.RIGHT move[i] = 0
		
		move[DIR.RIGHT] = 1
		move[DIR.LEFT] = 0 // set the other direction to not move
		
		am_moving = true
	}
	if InputCheck(INPUT_VERB.LEFT) {
		if !diagonal 
			for(var i = 0; i < 360; i += 90) if i != DIR.LEFT move[i] = 0
		
		move[DIR.LEFT] = 1
		move[DIR.RIGHT] = 0 // set the other direction to not move
		
		am_moving = true
	}
	if InputCheck(INPUT_VERB.DOWN) && (!sliding || slide_vertical_allow) {
		if !diagonal 
			for(var i = 0; i < 360; i += 90) if i != DIR.DOWN move[i] = 0
		
		move[DIR.DOWN] = 1
		move[DIR.UP] = 0 // set the other direction to not move
		
		am_moving = true
	}
	if InputCheck(INPUT_VERB.UP) && (!sliding || slide_vertical_allow) {
		if !diagonal 
			for(var i = 0; i < 360; i += 90) if i != DIR.UP move[i] = 0
		
		move[DIR.UP] = 1
		move[DIR.DOWN] = 0 // set the other direction to not move
		
		am_moving = true
	}
	
	// interact
	if InputPressed(INPUT_VERB.SELECT) {
		var w = 2
        var __interactable_instances = array_concat([o_ow_interactable], interactable_instances)
		
		var __xw = -lengthdir_x(w, dir + 90)
		var __yw = lengthdir_y(w, dir + 90)
		
		if place_meeting(x + __xw, y + __yw, __interactable_instances) {
			var inst = instance_place(x + __xw, y + __yw, __interactable_instances)
			with inst
				event_user(0)
		}
	}
	
	// menu
	if InputPressed(INPUT_VERB.SPECIAL) && !o_dodge_controller.dodge_mode && !instance_exists(o_ui_menu) { // only allow while not in an overworld dodging section
		// swap the menu object depending on the world
		if global.world == WORLD_TYPE.DARK // dark world
			instance_create(o_ui_menu)
		else // light world
			instance_create(o_ui_menu_lw)
	}
	
	// play the step sounds
	if stepsounds && !sliding {
		if floor(image_index % 4) == 1 { // only if 1 <= image_index < 2
			if stepsound == 0 {
				audio_play(asset_get_index(stepsoundprefix + "1"))
				stepsound = 1
			}
		}
		else if floor(image_index % 4) == 3 { // only if 3 <= image_index < 4
			if stepsound == 0{
				audio_play(asset_get_index(stepsoundprefix + "2"))
				stepsound = 1
			}
		}
		else 
			stepsound = 0
	}
}

// if i am a follower and i am following the leader
else if follow && is_follower {
	x = record[0][pos]
	y = record[1][pos]
	
	dir = record[2][pos]
	running = record[3][pos]
	state = record[4][pos]
	sliding = record[5][pos]
	
	if get_leader().moving {
		array_insert_cycle(record[0], 0, get_leader().x)
		array_insert_cycle(record[1], 0, get_leader().y)
		array_insert_cycle(record[2], 0, get_leader().dir)
		array_insert_cycle(record[3], 0, get_leader().running)
		array_insert_cycle(record[4], 0, get_leader().state)
		array_insert_cycle(record[5], 0, get_leader().sliding)
	}
}
else if sliding{
	if instance_exists(slideinst) && !place_meeting(x, y, slideinst){
		sliding = false
		y -= 4
	}
    
	y += 4
}

moving = false
if lockeddir != -1 && move[lockeddir] == 0 // no clue what this does (i coded this a while ago sorry)
	lockeddir = -1

// actually move now
for (var i = 0; i < 360; i += 90) {
    if move[i] > 0 {
		if lockeddir == -1 {
			lockeddir = i
			dir = i
		}
		move[i] -= 1
		
		var xx = -lengthdir_x(currentspd, i + 90)
		var yy = lengthdir_y(currentspd, i + 90)
		
		var collsx = instance_place_list_ext(x + xx, y, o_block, 1)
		var collsy = instance_place_list_ext(x, y + yy, o_block, 1)
		var canmove_x = true
		var canmove_y = true
		
		for (var j = 0; j < array_length(collsx); ++j) {
		    if instance_exists(collsx[j]) && collsx[j].collide {
				canmove_x = false
				break
			}
		}
		for (var j = 0; j < array_length(collsy); ++j) {
		    if instance_exists(collsy[j]) && collsy[j].collide {
				canmove_y = false 
				break
			}
		}
		
		// collisions when sliding
		if sliding {
			if instance_exists(slideinst) {
				if !place_meeting(x + xx, y, slideinst) {
					canmove_x = false
				}
			}
		}
		
		if canmove_x 
			x += xx
		if canmove_y 
			y += yy
		
		// diagonal collisions
		if place_meeting(x + xx, y, o_block_diag) {
			y += sign(instance_place(x + xx, y, o_block_diag).image_yscale) * currentspd
		}
		if place_meeting(x, y + yy, o_block_diag) {
			x += sign(instance_place(x, y + yy, o_block_diag).image_xscale) * currentspd
		}
		
		moving = true;
	}
}

// just make it known that you are moving (if you are not the player)
if !is_player 
    && (x != xprevious || y != yprevious)
    && !is_in_battle && !is_enemy || sliding
    	moving = true
else if moving // if you are already "moving," and it is confirmed by checking your x and y positions, let you still be moving
    && (x != xprevious || y != yprevious)
    && !is_in_battle && !is_enemy {
        
}
else
	moving = false

// sprites
if moving && !is_in_battle && !is_enemy && s_dynamic && !s_override{
	if !startedmoving {
		startedmoving = true
		image_index = 1
	}
	if !running {
		image_speed = s_walk_ispd
	}
}
else if !is_in_battle && !is_enemy{
	startedmoving = false
	
	if floor(image_index) % 2 == 0 && !s_override && s_dynamic {
		image_speed = 0;
		image_index = 0
	}
}

// running sprites, walking sprites
if !is_in_battle && !is_enemy && s_dynamic && !s_override{
	if running && moving {
		image_speed = lerp(s_walk_ispd, s_run_ispd, (get_leader().spd - basespd) / (runspd - basespd))
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
		fsiner++
}
{ // trail 
	if run_away && hurt <= 0 && is_enemy { // spawn the trail upon running away
		afterimage()
		for (var i = 2; i <= 30; i += 2) {
			var o = afterimage()
			o.x += i
			o.sprite_index = s_hurt
			o.image_alpha = 1
			o.depth = depth-10
		}
		x += 30
	
		run_away_timer ++
		if run_away_timer > 4 
			instance_destroy()
	}

	if trail 
		afterimage()
}
		
// overworld battle
if o_dodge_controller.dodge_mode && is_player {
	if !instance_exists(dodge_mysoul) {
		dodge_mysoul = instance_create(o_dodge_soul, x, y - sprite_height/2 + 4, depth, {caller: id})
	}
}