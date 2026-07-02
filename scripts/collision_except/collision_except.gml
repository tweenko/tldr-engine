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
