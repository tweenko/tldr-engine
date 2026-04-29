/// @desc	gets the instance id of a marker in the room
/// @arg	{real|string}	type type of the marker
/// @arg	{real|string}	id id of the marker you are looking for
/// @return	{Id.Instance}
function marker_get(_m_type, _m_id){
	with(o_dev_marker) {
		if m_type == _m_type && m_id == _m_id 
			return id
	}
    
	return noone
}

/// @desc	gets the instance id of the closest marker to the speicified point
/// @arg	{real}	x x position of the point
/// @arg	{real}	y y position of the point
/// @arg	{real|string}	type type of the marker you are looking for
/// @return	{Id.Instance}
function marker_find_closest(xx, yy, mtype){
    var record_dist = infinity
    var _ret = noone
    
	with(o_dev_marker) {
		var __a = distance_to_point(xx, yy)
		if m_type == mtype && __a < record_dist {
			record_dist = __a
			_ret = id
		}
	}
	return _ret
}