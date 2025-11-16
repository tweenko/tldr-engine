///@desc creates an actor object
///@arg {asset.GMObject | struct} obj
function actor_create(obj, xx = 0, yy = 0, ddepth = 0){
	if is_struct(obj) {
		var inst = instance_create(obj.obj, xx, yy, ddepth, obj.var_struct)
        with inst
            event_user(2)
        return inst
    }
	else {
		var inst = instance_create(obj, xx, yy, ddepth)
        with inst
            event_user(2)
        return inst
    }
}

/// @desc finds an actor in the room
/// @arg {asset.GMObject|struct} obj
/// @arg {real} xx the x position relative to which the nearest instance should be found
/// @arg {real} yy the y position relative to which the nearest instance should be found
/// @arg {real} snap if the distance is lower than the value of snap, then the loop will be broken and the instance returned. set to 0 to disable
/// @arg {struct} require the required variables and their values for the actor to be registered as the same
function actor_find(obj, xx = x, yy = y, snap = 10, require = {}) {
	if is_struct(obj) {
        var record_dist = infinity
        var record_instance = noone
        
        var full_struct = struct_merge(obj.var_struct, require, false)
        var n = struct_get_names(full_struct)
        
		with obj.obj {
			var me = true
            
			for (var i = 0; i < array_length(n); ++i) {
				if struct_get(full_struct, n[i]) == variable_instance_get(id, n[i]) {}
				else {
					me = false
					break
				}
			}
			if me {
				var __mydist = point_distance(xx, yy, x, y)
                
                if __mydist < record_dist {
                    record_dist = __mydist
                    record_instance = id
                }
                if __mydist < snap
                    break
			}
		}
        
		return record_instance
	}
	else {
		var record_dist = infinity
        var record_instance = noone
        
        var full_struct = require
        var n = struct_get_names(full_struct)
        
		with obj {
			var me = true
            
			for (var i = 0; i < array_length(n); ++i) {
				if struct_get(full_struct, n[i]) == variable_instance_get(id, n[i]) {}
				else {
					me = false
					break
				}
			}
			if me {
				var __mydist = point_distance(xx, yy, x, y)
                
                if __mydist < record_dist {
                    record_dist = __mydist
                    record_instance = id
                }
                if __mydist < snap
                    break
			}
		}
        
        return record_instance
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
function actor_movement(_x, _y, _time, _seed = "", _spd = undefined, _char_dir = undefined, _absolute = true) constructor {
    xx = _x
    yy = _y
    seed = _seed
    time = _time
    spd = _spd
    char_dir = _char_dir
    absolute = _absolute
}

/// @desc  a constructor for actor jump movement. inherits from actor_movement.
/// @param {real} _x target X position
/// @param {real} _y target Y position
/// @param {bool} [_absolute] whether the X and Y positions are absolute
function actor_movement_jump(_x, _y, _absolute = true) : actor_movement(_x, _y, 20, "jump", undefined, undefined, _absolute) constructor {}

///@desc	moves an actor using a struct
///@arg		{Id.Instance|Asset.GMObject}	actor		the actor to move
///@arg		{array|struct.actor_movement}	movement	array of the movement pattern
function actor_move(_actor, movement, pos = 0){
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
    inst.pos = pos
	
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