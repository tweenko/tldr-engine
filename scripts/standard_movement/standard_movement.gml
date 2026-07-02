function player_standard_movement_locomote(_colo, _xcep, _speed, _forcekeys = -1, _useplayerhorizontalinput = true, _useplayerverticalinput = true){
	// Define
	am_locomoting = false
	locomotionX = 0
	locomotionY = 0
	am_trying_to_locomoteX = false
	failed_locomote_X = false
	am_trying_to_locomoteY = false
	failed_locomote_Y = false
	
	// Walk and force keys
	var yaw = 270
	var attemptX=0
	var attemptY=0
	if _useplayerhorizontalinput==true attemptX = _speed * InputOpposing(INPUT_VERB.LEFT, INPUT_VERB.RIGHT, 0, true)
	if _useplayerverticalinput==true attemptY = _speed * InputOpposing(INPUT_VERB.UP, INPUT_VERB.DOWN, 0, true)
	if is_array(_forcekeys){ // If forcekey is an array, for example [0,1,0,0], [0,0,1,1], etc, it is ordered Left, Right, Down, Up, which you can set to 0 or 1.
		attemptX =  _speed * (_forcekeys[0]+_forcekeys[1])
		attemptY =  _speed * (_forcekeys[2]+_forcekeys[3])
	}
	locomotionX += (lengthdir_x(-attemptX,yaw-90)+lengthdir_x(attemptY,yaw))
	locomotionY += (lengthdir_y(-attemptX,yaw-90)+lengthdir_y(attemptY,yaw))
	if place_meeting_except(x+sign(attemptX), y, _colo, _xcep)
	or place_meeting_except(x, y+sign(attemptY), _colo, _xcep) {
		locomotionX = clamp(abs(locomotionX), 0, basespd+1)*sign(locomotionX)
		locomotionY = clamp(abs(locomotionY), 0, basespd+1)*sign(locomotionY)
	}
	var rv=0.5
	if !place_meeting_except(x+round_p(locomotionX,rv), y, _colo, _xcep) {locomotionX = round_p(locomotionX,rv)}
	if !place_meeting_except(x, y+round_p(locomotionY,rv), _colo, _xcep) {locomotionY = round_p(locomotionY,rv)}
	if locomotionX!=0 am_trying_to_locomoteX=true
	if locomotionY!=0 am_trying_to_locomoteY=true
	
	// Walking collision pardons
	var _slinv = array_concat(_xcep, [o_noslope])
	if locomotionY = 0 and place_meeting_except(x+locomotionX, y, _colo, _slinv){
		var t = locomotionX
		if !place_meeting_except(x+t, y+t, _colo, _xcep) locomotionY = t
		else if !place_meeting_except(x+t, y-t, _colo, _xcep) locomotionY = -t
	}
	else if locomotionY = 0 and place_meeting_except(x+sign(locomotionX), y, _colo, _slinv){
		var t = sign(locomotionX)
		if !place_meeting_except(x+t, y+t, _colo, _xcep) locomotionY = t
		else if !place_meeting_except(x+t, y-t, _colo, _xcep) locomotionY = -t
	}
	if locomotionX = 0 and place_meeting_except(x, y+locomotionY, _colo, _slinv){
		var t = locomotionY
		if !place_meeting_except(x+t, y+t, _colo, _xcep) locomotionX = t
		else if !place_meeting_except(x-t, y+t, _colo, _xcep) locomotionX = -t
	}
	else if locomotionX = 0 and place_meeting_except(x, y+sign(locomotionY), _colo, _slinv){
		var t = sign(locomotionY)
		if !place_meeting_except(x+t, y+t, _colo, _xcep) locomotionX = t
		else if !place_meeting_except(x-t, y+t, _colo, _xcep) locomotionX = -t
	}
	if place_meeting_except(x+locomotionX, y+locomotionY, _colo, _xcep){
		var six = sign(locomotionX)
		var siy = sign(locomotionY)
		var bsx = (six*basespd)
		var bsy = (siy*basespd)
		var pfx = (six*0.5)
		var pfy = (siy*0.5)
		if !place_meeting_except(x+locomotionX, y+bsy, _colo, _xcep) locomotionY = bsy
		else if !place_meeting_except(x+bsx, y+locomotionY, _colo, _xcep) locomotionX = bsx
		else if !place_meeting_except(x+locomotionX, y+siy, _colo, _xcep) locomotionY = siy
		else if !place_meeting_except(x+six, y+locomotionY, _colo, _xcep) locomotionX = six
		else if !place_meeting_except(x+locomotionX, y+pfy, _colo, _xcep) locomotionY = pfy
		else if !place_meeting_except(x+pfx, y+locomotionY, _colo, _xcep) locomotionX = pfx
		else if !place_meeting_except(x+locomotionX, y, _colo, _xcep) locomotionY = 0
		else if !place_meeting_except(x, y+locomotionY, _colo, _xcep) locomotionX = 0
	}
	
	// Final check
	if place_meeting_except(x+locomotionX, y+locomotionY, _colo, _xcep) {locomotionX = 0; locomotionY = 0}
	
	// Move the player
	if locomotionX != 0 {
        x += locomotionX; 
        am_locomoting = true;
    }
	if locomotionY != 0 {
        y += locomotionY; 
        am_locomoting = true
    }
	if am_trying_to_locomoteX==true and locomotionX==0 failed_locomote_X=true
	if am_trying_to_locomoteY==true and locomotionY==0 failed_locomote_Y=true
        
	moving = am_locomoting
	
	// Set the player's direction
	var kl = attemptX<0 ? 1 : 0
	var kr = attemptX>0 ? 1 : 0
	var ku = attemptY<0 ? 1 : 0
	var kd = attemptY>0 ? 1 : 0
	
	if !variable_global_exists("loco_key_first") global.loco_key_first=-1
	
	if !kl and global.loco_key_first == DIR.LEFT global.loco_key_first = -1
	if !kr and global.loco_key_first == DIR.RIGHT global.loco_key_first = -1
	if !ku and global.loco_key_first == DIR.UP global.loco_key_first = -1
	if !kd and global.loco_key_first == DIR.DOWN global.loco_key_first = -1
	
	if kl and kr and ku and kd global.loco_key_first = -1
	else if global.loco_key_first == -1 and kr global.loco_key_first = DIR.RIGHT
	else if global.loco_key_first == -1 and kl global.loco_key_first = DIR.LEFT
	else if global.loco_key_first == -1 and ku global.loco_key_first = DIR.UP
	else if global.loco_key_first == -1 and kd global.loco_key_first = DIR.DOWN
	else if !kl and !kr and !ku and !kd global.loco_key_first = -1
	
	if failed_locomote_X and failed_locomote_Y global.loco_key_first = -1
	
	if global.loco_key_first == DIR.RIGHT and locomotionX<0 global.loco_key_first = DIR.LEFT
	if global.loco_key_first == DIR.LEFT and locomotionX>0 global.loco_key_first = DIR.RIGHT
	if global.loco_key_first == DIR.DOWN and locomotionY<0 global.loco_key_first = DIR.UP
	if global.loco_key_first == DIR.UP and locomotionY>0 global.loco_key_first = DIR.DOWN
	
	if global.loco_key_first!=-1 dir = global.loco_key_first
}

function player_standard_movement_execute(){
	// Mask
	mask_index = playermask
	
	// Caterpillar spacing
	for (var i = 0; i < party_length(true); ++i) {
		var pinst = party_get_inst(global.party_names[i]);
		var targpos = get_leader().spacing * party_get_index(global.party_names[i]);
		pinst.pos = increment_towards(pinst.pos, targpos, 2);
	}
	
	// Movement speed
	auto_run = global.settings.AUTO_RUN
	if ((!auto_run and InputCheck(INPUT_VERB.CANCEL)) or (auto_run and !InputCheck(INPUT_VERB.CANCEL))) and moving {
		running = true;
		runtimer ++;
        
		if global.world == WORLD_TYPE.LIGHT {
			spd = basespd + 1
			if runtimer > 10 
                spd = basespd+2;
			if runtimer > 60 
                spd = basespd+3;
		}
        else{
			spd = basespd + 1
			if runtimer > 10 
                spd = basespd+2;
			if runtimer > 60 
                spd = basespd+2.5;
		}
	}
    else {
		running = false
		runtimer = 0
		spd = basespd
	}

	// Locomote
	moving = false
    
    // re-calculate collisions
    player_array_collisions = [];
    for (var i = 0; i < instance_number(o_block); ++i) {
		var inst = instance_find(o_block, i);
		if variable_instance_exists(inst, "collide") and inst.collide {array_push(player_array_collisions, inst)};
	}
    
	var __c = noclip ? noone : player_array_collisions;
	player_standard_movement_locomote(__c, player_array_exceptions, spd);
}