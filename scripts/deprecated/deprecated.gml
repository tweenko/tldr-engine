// This is the script for functions that may be in use in projects. These are useful for people who are changing versions; however, you shouldn't use these unless there is no alternative.

/// @ignore
/// @deprecated
function lerp_type(_val1, _val2, _amount, _ease_type) {
    return anime_curve_lerp(_val1, _val2, _amount, _ease_type)
}

/// @ignore
/// @deprecated
function do_animate(_val1, _val2, _time, _ease_type, _instance, _var_name) {
    return animate(_val1, _val2, _time, _ease_type, _instance, _var_name)
}

/// @ignore
/// @deprecated
function do_anime(_val1,_val2, _time, _ease_type, _call_method, _call_args = undefined) {
	var _container_method = method({_call_method, _call_args}, function(_val) {
		method_call(_call_method, array_concat([_val], _call_args))
	})
    return anime_tween(_val1, _val2, _time, _ease_type, _container_method)
}

/// @ignore
/// @deprecated
function save_set(slot) {
    global.save_slot = slot
}

/// @ignore
/// @deprecated
function enc_sparepercent_enemy(target, percent, sfx = snd_mercyadd) {
    return enc_enemy_add_spare(target, percent, sfx)
}

/// @ignore
/// @deprecated
function enc_sparepercent_enemy_from_inst(target, instance, variable, sfx = snd_mercyadd) {
    return enc_enemy_add_spare_from_var(target, instance, variable, sfx)
}

/// @ignore
/// @deprecated
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

///@deprecated
function volume_get(type){
	if type == AUDIO.SOUND
		return o_world.volume_sfx * o_world.volume_master
    if type == AUDIO.MUSIC
		return o_world.volume_bgm * o_world.volume_master
    
	return 0
}

///@deprecated
function instance_clean(inst) {
	if instance_exists(inst)
		instance_destroy(inst)
}

///@deprecated
function cutscene_set(_cutscene) {
	cutscene_set_current(_cutscene)
}
///@deprecated
function cutscene_get() {
    return cutscene_get_current()
}
///@deprecated
function cutscene_actor_move_old(target, movement, pos, wait = true) {
    return cutscene_actor_move(target, movement, wait)
}