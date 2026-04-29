// This is the script for functions that may be in use in projects. These are useful for people who are changing versions; however, you shouldn't use these unless there is no alternative.

/// @ignore
/// @deprecated
/// renamed to `anime_curve_lerp`
function lerp_type(_val1, _val2, _amount, _ease_type) {
    return anime_curve_lerp(_val1, _val2, _amount, _ease_type)
}

/// @ignore
/// @deprecated
/// old syntax for the more modern `animate` function
function do_animate(_val1, _val2, _time, _ease_type, _instance, _var_name) {
    return animate(_val1, _val2, _time, _ease_type, _instance, _var_name)
}

/// @ignore
/// @deprecated
/// old syntax for the more modern `anime_tween` function
function do_anime(_val1,_val2, _time, _ease_type, _call_method, _call_args = undefined) {
	var _container_method = method({_call_method, _call_args}, function(_val) {
		method_call(_call_method, array_concat([_val], _call_args))
	})
    return anime_tween(_val1, _val2, _time, _ease_type, _container_method)
}

/// @ignore
/// @deprecated
/// renamed to `enc_enemy_add_spare`
function enc_sparepercent_enemy(target, percent, sfx = snd_mercyadd) {
    return enc_enemy_add_spare(target, percent, sfx)
}

/// @ignore
/// @deprecated
/// renamed to `enc_enemy_add_spare_from_var`
function enc_sparepercent_enemy_from_inst(target, instance, variable, sfx = snd_mercyadd) {
    return enc_enemy_add_spare_from_var(target, instance, variable, sfx)
}

/// @ignore
/// @deprecated
/// replaced with the better `marker_get` that uses less power by simply returning the target marker object
function marker_getpos(mtype, mid){
	with(o_dev_marker) {
		if m_type == mtype && m_id == mid 
			return {
                x: x,
                y: y
            }
	}
    
	return undefined
}

/// @ignore
///@deprecated
/// not used anymore because the volume is controlled by the buses now
function volume_get(type){
	if type == AUDIO.SOUND
		return o_world.volume_sfx * o_world.volume_master
    if type == AUDIO.MUSIC
		return o_world.volume_bgm * o_world.volume_master
    
	return 0
}

/// @ignore
///@deprecated
/// useless. can be replaced with `instance_destroy`, as it already checks whether an object exists or not
function instance_clean(inst) {
	if instance_exists(inst)
		instance_destroy(inst)
}

/// @ignore
///@deprecated
/// renamed to `cutscene_set_current`
function cutscene_set(_cutscene) {
	cutscene_set_current(_cutscene)
}
/// @ignore
///@deprecated
/// renamed to `cutscene_get_current`
function cutscene_get() {
    return cutscene_get_current()
}
/// @ignore
///@deprecated
/// same as `cutscene_actor_move` but with the `pos` argument. it doesn't do anything anymore, but to keep syntax simillar, this option is presented
function cutscene_actor_move_old(target, movement, pos, wait = true) {
    return cutscene_actor_move(target, movement, wait)
}

/// @ignore
///@deprecated
/// renamed to `party_contains`
function party_ismember(name, full) {
    return party_contains(name, full)
}

/// @ignore
/// @deprecated
/// replaced with memories
function state_add(type, identificator = undefined) {
    identificator ??= (variable_instance_exists(self, "id") ? id : 0)
    memory_flick(type, identificator, true)
}
/// @ignore
/// @deprecated
/// replaced with memories
function state_get(type, identificator = undefined) {
    identificator ??= (variable_instance_exists(self, "id") ? id : 0)
    memory_get(type, identificator)
}
/// @ignore
/// @deprecated
/// replaced with memories
function state_remove(type, identificator = undefined) {
    identificator ??= (variable_instance_exists(self, "id") ? id : 0)
    memory_remove(type, identificator)
}

/// @ignore
/// @deprecated
/// use `marker_find_closest` instead
function marker_find_closest_id(xx, yy, mtype){
	var _ret = {
		dist: infinity, 
		m_id: ""
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

/// @ignore
/// @deprecated
/// renamed to `marker_find_closest`
function marker_find_closest_inst(xx, yy, mtype){
	return marker_find_closest(xx, yy, mtype)
}