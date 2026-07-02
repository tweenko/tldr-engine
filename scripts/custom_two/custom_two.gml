// -- Misc --

/// @desc Returns if value is or is between a minimum and maximum.
function ioib(value, minimum, maximum) {return value >= minimum && value <= maximum;}

/// @desc Lerp with snapping
function lerp_snap(a, b, amt, range=0.1){
	if a == b return b;
	else if ioib(a, b-range, b+range) return b;
	else return lerp(a, b, amt);
}

/// @desc Linear step with snapping
function linear(current, target, increment){
	var _r = current
	if ioib(current,target-increment,target+increment) {_r=target} else if current<target {_r+=increment} else {_r-=increment}
	return _r
}

/// @desc Reset matrix
function matrix_reset(){
	matrix_set(matrix_world, matrix_build_identity())
}

/// @desc Wrap
/// @param {Real} value The value being checked
/// @param {Real} min The minimum
/// @param {Real} max The maximum
function wrap02(_val, minimum, maximum){
	var _mod = (_val - minimum) mod (maximum - minimum)
	return _mod<0 ? _mod+maximum : _mod+minimum
}

/// @desc Move with collision without slope support and returns the id of what's being collided with.
function move_and_collide_simple02(xch, ych, obj){
	var tx = sign(xch), ty = sign(ych), col = noone, colid = noone;

	col = instance_place(x+xch, y, obj)
	if col!=noone{
		repeat(abs(xch)+1) {if place_meeting(x+tx, y, obj) break; x+=tx}
		xch = 0
		colid = col
	}
	x+=xch

	col = instance_place(x, y+ych, obj)
	if col!=noone{
		repeat(abs(ych)+1) {if place_meeting(x, y+ty, obj) break; y+=ty}
		ych = 0
		colid = col
	}
	y+=ych

	return colid
}

// -- Collide, except --

/// @desc Check place meeting but not when meeting with _exc
function place_meeting_except(_x, _y, _obj, _exc){
	var r = false
	if place_meeting(_x, _y, _obj) {r = true}
	if r==true and place_meeting(_x, _y, _exc) {r = false}
	return r
}

/// @desc Check place meeting but not when meeting with _exc
function position_meeting_except(_x, _y, _obj, _exc){
	var r = false
	if position_meeting(_x, _y, _obj) {r = true}
	if r==true and position_meeting(_x, _y, _exc) {r = false}
	return r
}

/// @desc Check point meeting but not when meeting with _exc
function collision_point_except(_x1, _y1, _obj, _exc, _precise = true, _notme = true){
	var r = false
	if collision_point(_x1, _y1, _obj, _precise, _notme) {r = true}
	if collision_point(_x1, _y1, _obj, _precise, _notme) and collision_point(_x1, _y1, _exc, _precise, _notme) {r = false}
	return r
}

/// @desc Check line meeting but not when meeting with _exc
function collision_line_except(_x1, _y1, _x2, _y2, _obj, _exc, _precise = true, _notme = true){
	var r = false
	if collision_line(_x1, _y1, _x2, _y2, _obj, _precise, _notme) {r = true}
	if collision_line(_x1, _y1, _x2, _y2, _obj, _precise, _notme) and collision_line(_x1, _y1, _x2, _y2, _exc, _precise, _notme) {r = false}
	return r
}


/// @desc Check rectangle meeting but not when meeting with _exc
function collision_rectangle_except(_x1, _y1, _x2, _y2, _obj, _exc, _precise = true, _notme = true){
	var r = false
	if collision_rectangle(_x1, _y1, _x2, _y2, _obj, _precise, _notme) {r = true}
	if collision_rectangle(_x1, _y1, _x2, _y2, _obj, _precise, _notme) and collision_rectangle(_x1, _y1, _x2, _y2, _exc, _precise, _notme) {r = false}
	return r
}


/// @desc Check place meeting but not when meeting with _exc
function collision_circle_except(_x, _y, _radius, _obj, _exc, _precise = true, _notme = true){
	var r = false
	if collision_circle(_x, _y, _radius, _obj, _precise, _notme) {r = true}
	if collision_circle(_x, _y, _radius, _obj, _precise, _notme) and collision_circle(_x, _y, _radius, _exc, _precise, _notme) {r = false}
	return r
}

// -- Subimg Auto --

/// @function subimg_auto_sprite(sprite);
/// @param {asset}          _sprite
/// @description            Retrieves the current subimage for the fps set within the sprite asset.
function subimg_auto_sprite(_sprite, _time=current_time) // or (sprite = image_index)
{
	return _time / (1000 / sprite_get_speed(_sprite));
}

/// @function subimg_auto_fps(fps);
/// @param {real}           _fps
/// @description            Retrieves the current subimage for the specified fps.
function subimg_auto_fps(_fps, _time=current_time)
{
	return _time / (1000 / _fps);
}
