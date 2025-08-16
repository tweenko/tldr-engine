/// @desc	gets the id of the closest marker to the speicified point
/// @arg	{real}	x x position of the point
/// @arg	{real}	y y position of the point
/// @arg	{real}	type type of the marker you are looking for
/// @return	{real}
function marker_find_closest(xx, yy, mtype){
	var _ret = {
		dist: infinity, 
		m_id: 0
	}
	
	with(o_dev_marker) {
		var __a = distance_to_point(xx, yy)
		if m_type == mtype && __a < _ret.dist{
			_ret.dist = __a
			_ret.m_id = m_id
		}
	}
	return _ret.m_id
}


/// @desc	gets a position of a marker in the room. in case of failure, returns undefined
/// @arg	{real|string}	type type of the marker
/// @arg	{real}	id id of the marker you are looking for
/// @return	{array<real>|undefined}
function marker_getpos(mtype, mid){
	with(o_dev_marker) {
		if m_type == mtype && m_id == mid 
			return [x, y]
	}
    
	return undefined
}