///@desc creates an actor object
///@arg {asset.GMObject | struct} obj
function actor_create(obj, xx = 0, yy = 0, ddepth = 0){
	if is_struct(obj)
		return instance_create(obj.obj, xx, yy, ddepth, obj.var_struct)
	else
		return instance_create(obj, xx, yy, ddepth)
}

/// @desc (MIGHT be memory heavy) finds an actor in the room
/// @arg {asset.GMObject|struct} obj
/// @arg {real} xx the x position relative to which the nearest instance should be found
/// @arg {real} yy the y position relative to which the nearest instance should be found
function actor_find(obj, xx = x, yy = y) {
	if is_struct(obj) {
		var a = noone
		with obj.obj {
			var n = struct_get_names(obj.var_struct)
			var me = true
			for (var i = 0; i < array_length(n); ++i) {
				if struct_get(obj.var_struct, n[i]) == variable_instance_get(id, n[i]) {}
				else {
					me = false
					break
				}
			}
			if me {
				a = id;
				break
			}
		}
		return a
	}
	else {
		if instance_exists(obj)
			return instance_nearest(xx, yy, obj)
	}
	return noone
}

/// @desc  a constructor for the actor movement struct
/// @param {real} _x target X position
/// @param {real} _y target Y position
/// @param {real} _time time in which the actor gets from A to B
/// @param {string} _seed the seed of the movement. at the moment "jump" or ""
/// @param {real|undefined} [_spd] the speed at which the actor should move. leave undefined if the actor will move under time constraint
/// @param {enum.DIR|undefined} [_char_dir] the direction that the actor will be locked into
/// @param {bool} [_absolute] whether the X and Y positions are absolute
function __actor_movement(_x, _y, _time, _seed = "", _spd = undefined, _char_dir = undefined, _absolute = true) constructor {
    xx = _x
    yy = _y
    seed = _seed
    time = _time
    spd = _spd
    char_dir = _char_dir
    absolute = _absolute
}

/// @desc  a constructor for actor jump movement. inherits from __actor_movement.
/// @param {real} _x target X position
/// @param {real} _y target Y position
/// @param {bool} [_absolute] whether the X and Y positions are absolute
function __actor_movement_jump(_x, _y, _absolute = true) : __actor_movement(_x, _y, 20, "jump", undefined, undefined, _absolute) constructor {}

///@desc	moves an actor using a struct
///@arg		{Id.Instance|Asset.GMObject}	actor		the actor to move
///@arg		{array|struct.__actor_movement}	movement	array of the movement pattern
function actor_move(_actor, movement){
	if !instance_exists(_actor) 
        exit
	
	var inst = instance_create(o_actor_mover)	
	
	inst.character = _actor
	inst.xx = []
	inst.yy = []
	inst.seed = []
	inst.spd = []
	inst.time = []
	inst.char_dir = []
	
	if !is_array(movement) 
        movement = [movement]
	
	for (var i = 0; i < array_length(movement); ++i) {
		var absolute = true
		if struct_exists(movement[i], "absolute") 
            absolute = movement[i].absolute
		
		var xx = movement[i].xx
		if !absolute 
			xx = _actor.x + movement[i].xx
		
        var yy = movement[i].yy
		if !absolute 
			yy = _actor.y + movement[i].yy
		
		array_push(inst.xreq, xx)
		array_push(inst.yreq, yy)
		
		if struct_exists(movement[i], "seed") 
            array_push(inst.seed, movement[i].seed)
		else 
            array_push(inst.seed, "")
		
		if struct_exists(movement[i], "spd") 
            array_push(inst.spd, movement[i].spd)
		else 
            array_push(inst.spd, 2)
		
		if struct_exists(movement[i], "time") 
            array_push(inst.time, movement[i].time)
		else 
            array_push(inst.time, undefined)
		
		if struct_exists(movement[i], "char_dir") 
            array_push(inst.char_dir, movement[i].char_dir)
		else 
            array_push(inst.char_dir, undefined)
	}
	
	with inst
        event_user(0)
	return inst
}

/// @desc converts angle into char direction
function actor_angletodir(angle) {
	if (angle >= 225 && angle < 315)
		return DIR.DOWN;
	if (angle >= 315 || angle < 45)
		return DIR.RIGHT;
	if (angle >= 45 && angle < 135)
		return DIR.UP;
	if (angle >= 135 && angle < 225)
		return DIR.LEFT;
}