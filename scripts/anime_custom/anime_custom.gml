//feather ignore GM1042
//feather ignore GM2017

///@desc	Animates a value between two positions along a curve.
///			**NOTE:** For built-in easing curves use `anime_curve.[insert type]` or a string.
///			For custom curves use a function, animation curve, or animation curve channel.
///@param {Real} val1				The first value of the animation
///@param {Real} val2				The last value of the animation
///@param {Real} time				The duration in frames
///@param {String|Real|Function|Asset.GMAnimCurve|Struct} easing_curve
///									The easing curve
///@param {Id.Instance|Asset.GMObject}  instance        The instance the variable of you're animating
///@param {String}                      var_name        The variable name you're animating
///@param {Bool}                        [start]         Whether to start the animation with the function (true by default)
///@return {Struct.__anime_class}
function animate(_val1, _val2, _time, _easing_curve, _instance, _var_name, _start = true) {
    var _call_method = function(value, _instance, _var_name) {
        variable_instance_set(_instance, _var_name, value)
    }
    
    var anime_inst = anime_tween(_val1, _val2, _time, _easing_curve, _call_method, [_instance, _var_name])
    if _start
        anime_inst._start()
    
	return anime_inst
}