// This is the script for functions that may be in use in projects. These are useful for people who are changing versions; however, you shouldn't use these unless there is no alternative.

/// @ignore
function lerp_type(_val1, _val2, _amount, _ease_type) {
    return anime_curve_lerp(_val1, _val2, _amount, _ease_type)
}

/// @ignore
function do_animate(_val1, _val2, _time, _ease_type, _instance, _var_name) {
    return animate(_val1, _val2, _time, _ease_type, _instance, _var_name)
}
/// @ignore
function do_anime(_val1,_val2, _time, _ease_type, _call_method, _call_args) {
    return anime_tween(_val1, _val2, _time, _ease_type, _call_method, _call_args)._start()
}