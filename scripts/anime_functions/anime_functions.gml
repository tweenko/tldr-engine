//feather ignore GM1042
//feather ignore GM2017

#region anime instances

///@desc	Animates a value between two positions along a curve.
///			**NOTE:** For built-in easing curves use `anime_curve.[insert type]` or a string.
///			For custom curves use a function, animation curve, or animation curve channel.
///@param {Real} val1				The first value of the animation
///@param {Real} val2				The last value of the animation
///@param {Real} time				The duration in frames
///@param {String|Real|Function|Asset.GMAnimCurve|Struct} easing_curve
///									The easing curve
///@param {Function} [call_method]	The method to call each frame (defaults to undefined)
///@param {Function} [call_args]	The arguments to pass to the call method (defaults to an empty array)
///@return {Struct.__anime_class}
function anime_tween(_val1, _val2, _time, _easing_curve, _call_method = undefined, _call_args = []) {
	var _anime = new __anime_class(_val1, false, 1, _call_method, undefined, undefined, _call_args);
	_anime._add(_val2, _time, _easing_curve);
	return _anime;
}

///@desc	Begins a new animation. Use `anime_add()` to define positions then `anime_end()` to finish.
///			**NOTE:** The animation will start automatically, use `anime_begin_ext()` to prevent.
///@param {Real} val				The first value of the animation
///@param {Function} [call_method]	The method to call each frame (defaults to undefined)
///@return {Struct.__anime_class}
function anime_begin(_val, _call_method = undefined) {
	static _global = __anime_global();
	var _anime = new __anime_class(_val, false, 1, _call_method);
	_global._anime_current = _anime;
	_anime._start();
	return _anime;
}

///@desc	Begins a new animation. Use `anime_add()` to define positions then `anime_end()` to finish.
///@param {Real} val				The first value of the animation
///@param {Bool} [auto_start]		Whether to start the animation automatically (defaults to true)
///@param {Real} [loop]				Whether to loop (defaults to false)
///@param {Real} [speed]			The speed multiplier (defaults to 1)
///@param {Function} [call_method]	The method to call each frame (defaults to undefined)
///@param {Function} [stop_method]	The method to call when the animation stops (defaults to undefined)
///@return {Struct.__anime_class}
function anime_begin_ext(_val, _auto_start = true, _loop = false, _speed = 1, _call_method = undefined, _stop_method = undefined) {
	static _global = __anime_global();
	var _anime = new __anime_class(_val, _loop, _speed, _call_method, _stop_method);
	_global._anime_current = _anime;
	if (_auto_start) _anime._start();
	return _anime;
}

///@desc	Adds a new position to the current animation.
///			**NOTE:** For built-in easing curves use `anime_curve.[insert type]` or a string.
///			For custom curves use a function, animation curve, or animation curve channel.
///@param {Real} val		The value to animate to
///@param {Real} time		The duration in frames to arrive at the value
///@param {String|Real|Function|Asset.GMAnimCurve|Struct} [easing_curve]
///							The easing curve (defaults to `anime_curve.linear`)
function anime_add(_val, _time, _easing_curve = anime_curve.linear) {
	static _global = __anime_global();
	_global._anime_current._add(_val, _time, _easing_curve);
}

///@desc	Finishes defining the animation.
function anime_end() {
	static _global = __anime_global();
	_global._anime_current._end();
	_global._anime_current = undefined;
}

///@desc	Starts the animation.
///@param {Struct.__anime_class} anime	The anime instance
function anime_start(_anime) {
	if (!is_struct(_anime)) return;
	_anime._start();
}

///@desc	Stops the animation.
///@param {Struct.__anime_class} anime	The anime instance
function anime_stop(_anime) {
	if (!is_struct(_anime)) return;
	_anime._stop();
}

///@desc	Pauses the animation.
///@param {Struct.__anime_class} anime	The anime instance
function anime_pause(_anime) {
	if (!is_struct(_anime)) return;
	_anime._pause();
}

///@desc	Resumes the animation.
///@param {Struct.__anime_class} anime	The anime instance
function anime_resume(_anime) {
	if (!is_struct(_anime)) return;
	_anime._resume();
}

///@desc	Enables or disables looping. Use `anime_stop()` to exit looping animations.
///@param {Struct.__anime_class} anime	The anime instance
///@param {Real} [enable]				Whether to loop (defaults to true)
function anime_set_loop(_anime, _enable = true) {
	if (!is_struct(_anime)) return;
	_anime._set_loop(_enable);
}

///@desc	Sets the speed multiplier.
///@param {Struct.__anime_class} anime	The anime instance
///@param {Function} speed				The speed multiplier
function anime_set_speed(_anime, _speed) {
	if (!is_struct(_anime)) return;
	_anime._set_speed(_speed);
}

///@desc	Sets the callback method. The method must take the current value in the animation as an argument.
///@param {Struct.__anime_class} anime	The anime instance
///@param {Function} call_method		The method to call each frame
function anime_set_method(_anime, _call_method) {
	if (!is_struct(_anime)) return;
	_anime._set_method(_call_method);
}

///@desc	Sets the stop method. The method may optionally take the time remaining of the current step as an argument.
///@param {Struct.__anime_class} anime	The anime instance
///@param {Function} stop_method		The method to call when the animation stops
function anime_set_stop_method(_anime, _stop_method) {
	if (!is_struct(_anime)) return;
	_anime._set_method(_call_method);
}

///@desc	Sets the current position of the animation in frames.
///@param {Struct.__anime_class} anime	The anime instance
///@param {Function} time				The position in frames
function anime_set_time(_anime, _time) {
	if (!is_struct(_anime)) return;
	_anime._set_time(_time);
}

///@desc	Gets the current position of the animation in frames.
///@param {Struct.__anime_class} anime	The anime instance
///@return {Real}
function anime_get_time(_anime) {
	if (!is_struct(_anime)) return;
	return _anime._get_time();
}

///@desc	Gets the current value in the animation.
///@param {Struct.__anime_class} anime	The anime instance
///@return {Real}
function anime_get_value(_anime) {
	if (!is_struct(_anime)) return;
	return _anime._get_value();
}

///@desc	Gets the length of the animation in frames.
///@param {Struct.__anime_class} anime	The anime instance
///@return {Real}
function anime_get_length(_anime) {
	if (!is_struct(_anime)) return;
	return _anime._get_length();
}

///@desc	Manually increments the animation and calls the callback method.
///			This function works even if the animation is paused or stopped.
///@param {Struct.__anime_class} anime	The anime instance
///@param {Real} delta_time				The number of frames to increment the animation (defaults to 1)
///@return {Real}
function anime_step(_anime, _delta_time = 1) {
	_anime._step(_delta_time);
}

///@desc	Returns a duplicate of the animation. Useful for running multiple of the same animation.
///@param {Struct.__anime_class} anime	The anime instance to clone
///@return {Struct.__anime_class}
function anime_clone(_anime) {
	if (!is_struct(_anime)) return _anime;
	return _anime._clone();
}

#endregion

#region easing curves

///@desc	Assign a name to a custom easing curve.
///@param {String} name			The name of the easing curve
///@param {Function|Asset.GMAnimCurve|Struct} function_or_animcurve
///								The function, animation curve, or animation curve channel
///@param {Real} [curve_dir]	The direction of the curve (defaults to `anime_curve_dir.normal`)
function anime_curve_add_custom(_name, _function_or_animcurve, _direction = anime_curve_dir.normal) {
	static _curve_struct = __anime_global()._curve_struct;
	_curve_struct[$ _name] = [_function_or_animcurve, _direction];
}

///@desc	Interpolate two values with an easing curve.
///			**NOTE:** For built-in easing curves use `anime_curve.[insert type]` or a string.
///			For custom curves use a function, animation curve, or animation curve channel.
///@param {Real} val1				The first value
///@param {Real} val2				The second value
///@param {Real} amount				The amount to interpolate
///@param {String|Real|Function|Asset.GMAnimCurve|Struct} easing_curve
///									The easing curve
///@param {Real} [curve_dir]		The direction of the curve (only for custom curves)
///@return {Real}
function anime_curve_lerp(_val1, _val2, _amount, _easing_curve, _curve_dir = anime_curve_dir.normal) {
	static _curve_array = __anime_global()._curve_array;
	static _curve_struct = __anime_global()._curve_struct;
	
	static _animcurve_method = function(_amount, _channel) {
		return animcurve_channel_evaluate(_channel, _amount);
	}
	
	//built-in curves
	if (is_numeric(_easing_curve)) {
		var _curve = _curve_array[_easing_curve];
		_easing_curve = _curve[0];
		_curve_dir = _curve[1];
	} else if (is_string(_easing_curve)) {
		var _curve = _curve_struct[$ _easing_curve];
		if (_curve == undefined) {
			var _message = $"ANIME: Easing curve \"{_easing_curve}\" does not exist.";
			show_message(_message);
			throw _message;
		}
		_easing_curve = _curve[0];
		_curve_dir = _curve[1];
	}
	
	_amount = clamp(_amount, 0, 1);
	var _channel = undefined;
	
	//animcurve channel
	if (!is_callable(_easing_curve)) {
		if animcurve_exists(_easing_curve) {
			_easing_curve = animcurve_get_channel(_easing_curve, 0);
		}
		_channel = _easing_curve;
		_easing_curve = _animcurve_method;
	}
	
	switch (_curve_dir) {
	default: //normal
		return (_val2 - _val1) * _easing_curve(_amount, _channel) + _val1;
	case anime_curve_dir.reverse: //reverse
		return (_val1 - _val2) * _easing_curve(1 - _amount, _channel) + _val2;
	case anime_curve_dir.alternate: //normal-reverse
		_amount = 2 * _amount - 1;
		var _s1 = sign(_amount);
		return (_val2 - _val1) * (0.5 * (1 - _easing_curve(1 - _s1 * _amount, _channel)) * _s1 + 0.5) + _val1;
	case anime_curve_dir.alt_reverse: //reverse-normal
		_amount = 2 * _amount - 1;
		var _s2 = sign(_amount);
		return (_val2 - _val1) * (0.5 * _easing_curve(_s2 * _amount, _channel) * _s2 + 0.5) + _val1;
	}
}

#endregion

#region macros / enums

#macro anime_state_initial 0
#macro anime_state_active 1
#macro anime_state_paused 2
#macro anime_state_stopped 3

enum anime_curve_dir {
	normal, reverse, alternate, alt_reverse
}

enum anime_curve {
	quad_in, quad_out, quad_in_out,
	
	cubic_in, cubic_out, cubic_in_out,
	
	quart_in, quart_out, quart_in_out,
	
	quint_in, quint_out, quint_in_out,
	
	expo_in, expo_out, expo_in_out,
	
	sine_in, sine_out, sine_in_out,
	
	circ_in, circ_out, circ_in_out,
	
	back_in, back_out, back_in_out,
	
	elastic_in, elastic_out, elastic_in_out,
	
	bounce_in, bounce_out, bounce_in_out,
	
	hold, linear
}

#endregion



#region internal

///@ignore
function __anime_global() {
	static _class = function() constructor {
		_anime_current = undefined;
		_curve_array = [];
		_curve_struct = {};
		
		#region curve methods
		var _linear = function(_val) { return _val; };
		var _hold = function(_val) { return (_val >= 1); };
		var _quad = function(_val) { return _val * _val; }
		var _cubic = function(_val) { return _val * _val * _val; }
		var _quart = function(_val) { return _val * _val * _val * _val; }
		var _quint = function(_val) { return _val * _val * _val * _val * _val; }
		var _expo = function(_val) { return (_val <= 0) ? 0 : exp(_val * 7 - 7); }
		var _sine = function(_val) { return sin(_val * pi * 0.5); }
		var _circ = function(_val) { return 1 - sqrt(max(1 - (_val * _val), 0)); }
		var _back = function(_val) {
			var _c1 = 1.70158;
			var _c3 = _c1 + 1;
			return (_c3 * _val - _c1) * _val * _val;
		}
		var _elastic = function(_val) {
			var _c4 = 2 * pi / 3;
			if (_val <= 0) return 0;
			if (_val >= 1) return 1;
			return power(2, -10 * _val) * sin((_val * 10 - 0.75) * _c4) + 1;
		}
		var _bounce = function(_val) {
			var _n1 = 7.5625;
			var _d1 = 2.75;
			if (_val < 1 / _d1) {
			    return _n1 * _val * _val;
			} else if (_val < 2 / _d1) {
				_val -= 1.5 / _d1;
			    return _n1 * _val * _val + 0.75;
			} else if (_val < 2.5 / _d1) {
				_val -= 2.25 / _d1;
			    return _n1 * _val * _val + 0.9375;
			} else {
				_val -= 2.625 / _d1;
			    return _n1 * _val * _val + 0.984375;
			}
		}
		#endregion
		
		#region register curves
		var _register = function(_index, _name, _method, _direction) {
			var _curve = [_method, _direction];
			_curve_array[_index] = _curve;
			_curve_struct[$ _name] = _curve;
		}
		_register(anime_curve.linear,         "linear",         _linear,  anime_curve_dir.normal     );
		_register(anime_curve.hold,           "hold",           _hold,    anime_curve_dir.normal     );
		_register(anime_curve.quad_in,        "quad_in",        _quad,    anime_curve_dir.normal     );
		_register(anime_curve.quad_out,       "quad_out",       _quad,    anime_curve_dir.reverse    );
		_register(anime_curve.quad_in_out,    "quad_in_out",    _quad,    anime_curve_dir.alternate  );
		_register(anime_curve.cubic_in,       "cubic_in",       _cubic,   anime_curve_dir.normal     );
		_register(anime_curve.cubic_out,      "cubic_out",      _cubic,   anime_curve_dir.reverse    );
		_register(anime_curve.cubic_in_out,   "cubic_in_out",   _cubic,   anime_curve_dir.alternate  );
		_register(anime_curve.quart_in,       "quart_in",       _quart,   anime_curve_dir.normal     );
		_register(anime_curve.quart_out,      "quart_out",      _quart,   anime_curve_dir.reverse    );
		_register(anime_curve.quart_in_out,   "quart_in_out",   _quart,   anime_curve_dir.alternate  );
		_register(anime_curve.quint_in,       "quint_in",       _quint,   anime_curve_dir.normal     );
		_register(anime_curve.quint_out,      "quint_out",      _quint,   anime_curve_dir.reverse    );
		_register(anime_curve.quint_in_out,   "quint_in_out",   _quint,   anime_curve_dir.alternate  );
		_register(anime_curve.expo_in,        "expo_in",        _expo,    anime_curve_dir.normal     );
		_register(anime_curve.expo_out,       "expo_out",       _expo,    anime_curve_dir.reverse    );
		_register(anime_curve.expo_in_out,    "expo_in_out",    _expo,    anime_curve_dir.alternate  );
		_register(anime_curve.sine_in,        "sine_in",        _sine,    anime_curve_dir.reverse    );
		_register(anime_curve.sine_out,       "sine_out",       _sine,    anime_curve_dir.normal     );
		_register(anime_curve.sine_in_out,    "sine_in_out",    _sine,    anime_curve_dir.alt_reverse);
		_register(anime_curve.circ_in,        "circ_in",        _circ,    anime_curve_dir.normal     );
		_register(anime_curve.circ_out,       "circ_out",       _circ,    anime_curve_dir.reverse    );
		_register(anime_curve.circ_in_out,    "circ_in_out",    _circ,    anime_curve_dir.alternate  );
		_register(anime_curve.back_in,        "back_in",        _back,    anime_curve_dir.normal     );
		_register(anime_curve.back_out,       "back_out",       _back,    anime_curve_dir.reverse    );
		_register(anime_curve.back_in_out,    "back_in_out",    _back,    anime_curve_dir.alternate  );
		_register(anime_curve.elastic_in,     "elastic_in",     _elastic, anime_curve_dir.reverse    );
		_register(anime_curve.elastic_out,    "elastic_out",    _elastic, anime_curve_dir.normal     );
		_register(anime_curve.elastic_in_out, "elastic_in_out", _elastic, anime_curve_dir.alt_reverse);
		_register(anime_curve.bounce_in,      "bounce_in",      _bounce,  anime_curve_dir.reverse    );
		_register(anime_curve.bounce_out,     "bounce_out",     _bounce,  anime_curve_dir.normal     );
		_register(anime_curve.bounce_in_out,  "bounce_in_out",  _bounce,  anime_curve_dir.alt_reverse);
		#endregion
	}
	static _global = new _class();
	return _global;
}

///@ignore
function __anime_class(_val, _loop = false, _speed = 1, _call_method = undefined, _stop_method = undefined, _positions = undefined, _call_args = []) constructor {
	///@ignore
	static _add = function(_val, _time, _easing_curve) {
		_length += _time;
		array_push(_positions, {
			_val: _val,
			_time: _length,
			_easing_curve: _easing_curve
		});
	}
	
	///@ignore
	static _end = function() {
		//avoid weird issues with 0 length animations
		if (_length <= 0) _add(array_last(_positions)._val, 1, anime_curve.linear);
	}
	
	///@ignore
	static _start = function() {
		_state = anime_state_active;
		_time = 0;
		_index = 0;
		_position1 = _positions[0];
		_position2 = _position1;
		_current_val = _position1._val;
		_time_source ??= call_later(1, time_source_units_frames, method(self, _step), true);
        
        self._step()
	}
	
	///@ignore
	static _stop = function(_time_remaining = 0) {
		_state = anime_state_stopped;
		if (_time_source != undefined) {
			call_cancel(_time_source);
			_time_source = undefined;
		}
		if (is_callable(_stop_method)) _stop_method(_time_remaining);
	}
	
	///@ignore
	static _pause = function() {
		if (_state != anime_state_active) return;
		_state = anime_state_paused;
		if (_time_source != undefined) {
			call_cancel(_time_source);
			_time_source = undefined;
		}
	}
	
	///@ignore
	static _resume = function() {
		if (_state != anime_state_paused) return;
		_state = anime_state_active;
		_time_source ??= call_later(1, time_source_units_frames, method(self, _step), true);
	}
	
	///@ignore
	static _set_loop = function(_enable) {
		_loop = _enable;
	}
	
	///@ignore
	static _set_speed = function(_speed) {
		self._speed = _speed;
	}
	
	///@ignore
	static _set_method = function(_call_method) {
		self._call_method = _call_method;
	}
	
	///@ignore
	static _set_stop_method = function(_stop_method) {
		self._stop_method = _stop_method;
	}
	
	///@ignore
	static _set_time = function(_new_time) {
		_time = _new_time;
		
		while (_time >= _position2._time) { //next position
			_index++;
			if (_index >= array_length(_positions)) {
				if (_loop) {
					_index = 0;
					_time = (_time - _length) % _length;
				} else {
					var _time_remaining = _time - _length;
					_time = _length;
					_current_val = _position2._val;
					_stop(_time_remaining);
					return;
				}
			}
			_position1 = _position2;
			_position2 = _positions[_index];
		}
		
		while (_time < _position1._time) { //previous position
			_index--;
			if (_index <= 0) {
				if (_loop) {
					_index = array_length(_positions);
					_time = (_time % _length + _length) % _length;
				} else {
					var _time_remaining = -_time;
					_time = 0;
					_current_val = _position1._val;
					_stop(_time_remaining);
					return;
				}
			}
			_position2 = _position1;
			_position1 = _positions[_index - 1];
		}
		
		var _start_time = _position1._time;
		var _amount = (_time - _start_time) / (_position2._time - _start_time);
		_current_val = anime_curve_lerp(_position1._val, _position2._val, _amount, _position2._easing_curve);
	}
	
	///@ignore
	static _get_time = function() {
		return _time;
	}
	
	///@ignore
	static _get_value = function() {
		return _current_val;
	}
	
	///@ignore
	static _get_length = function() {
		return _length;
	}
	
	///@ignore
	static _clone = function() {
		return new __anime_class(0, _loop, _speed, _call_method, _stop_method, _positions);
	}
	
	///@ignore
	static _step = function(_frames = 1) {
		_set_time(_time + _frames * _speed);
		if (is_callable(_call_method)) 
            method_call(_call_method, array_concat([_current_val], _call_args))
	}
	
	/**@ignore*/ self._loop = _loop;
	/**@ignore*/ self._speed = _speed;
	/**@ignore*/ self._call_method = _call_method;
	/**@ignore*/ self._call_args = _call_args;
	/**@ignore*/ self._stop_method = _stop_method;
	/**@ignore*/ self._positions = _positions ?? [{_val: _val, _time: 0, _easing_curve: 0}];
	/**@ignore*/ _length = array_last(self._positions)._time;
	
	/**@ignore*/ _state = anime_state_initial;
	/**@ignore*/ _time_source = undefined;
	/**@ignore*/ _time = 0;
	/**@ignore*/ _index = 0;
	/**@ignore*/ _position1 = self._positions[0];
	/**@ignore*/ _position2 = _position1;
	/**@ignore*/ _current_val = _position1._val;
}

#endregion