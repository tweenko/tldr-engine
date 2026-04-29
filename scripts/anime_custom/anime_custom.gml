//feather ignore GM1042
//feather ignore GM2017

/// @desc	Animates a value between two positions along a curve.
///			**NOTE:** For built-in easing curves use `anime_curve.[insert type]` or a string.
///			For custom curves use a function, animation curve, or animation curve channel.
/// @param {Real} val1				The first value of the animation
/// @param {Real} val2				The last value of the animation
/// @param {Real} time				The duration in frames
/// @param {Enum.anime_curve} easing_curve
///									The easing curve. `anime_curve.[insert type]` or a string
/// @param {Id.Instance|Asset.GMObject}  instance        The instance the variable of you're animating
/// @param {String}                      var_name        The variable name you're animating
/// @param {Bool}                        [start]         Whether to start the animation with the function (true by default)
/// @param {bool}                       [set_to_val1]   Whether the function should set your variable to the first value of the animation before starting it (usually yes)
/// @return {Struct.__anime_class}
function animate(_val1, _val2, _time, _easing_curve, _instance, _var_name, _start = true, _set_to_val1 = true) {
    var _call_method = method({_instance, _var_name}, function(value) {
        variable_instance_set(_instance, _var_name, value);
    })
    
    if _set_to_val1
        _call_method(_val1);
    
    var anime_inst = anime_begin_ext(_val1, _start, false, 1, _call_method);
	anime_add(_val2, _time, _easing_curve);
	anime_end();
    
	return anime_inst;
}