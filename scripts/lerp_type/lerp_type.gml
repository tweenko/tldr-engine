///@desc	Interpolate two values with an easing curve.
///@param {Real} val1				The first value
///@param {Real} val2				The second value
///@param {Real} amount				The _amount to interpolate
///@param {String} ease_type		The easing curve
///@return {Real}
function lerp_type(_val1, _val2, _amount, _ease_type) {
	#region interpolate functions
	static _quad = function(_val) {
		return _val * _val;
	}
	static _cubic = function(_val) {
		return _val * _val * _val;
	}
	static _quart = function(_val) {
		return _val * _val * _val * _val;
	}
	static _quint = function(_val) {
		return _val * _val * _val * _val * _val;
	}
	static _sine = function(_val) {
		return sin(_val * pi * 0.5);
	}
	static _expo = function(_val) {
		if (_val <= 0) return 0;
		return exp(_val * 7 - 7)
	}
	static _circ = function(_val) {
		return 1 - sqrt(max(1 - (_val * _val), 0));
	}
	static _back = function(_val) {
		static _c1 = 1.70158;
		static _c3 = _c1 + 1;
		
		return (_c3 * _val - _c1) * _val * _val;
	}
	static _elastic = function(_val) {
		static _c4 = 2 * pi / 3;
		
		if (_val <= 0) return 0;
		if (_val >= 1) return 1;
		return power(2, -10 * _val) * sin((_val * 10 - 0.75) * _c4) + 1;
	}
	static _bounce = function(_val) {
		static _n1 = 7.5625;
		static _d1 = 2.75;
		
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
	
	static _type = {
		"linear" : [0, function(_val) { return _val; }],
		"smooth" : [2, _quad],
		"nearest" : [0, function(_val) { return (_val >= 0.5); }],
		"hold" : [0, function(_val) { return (_val >= 1) }],
		 
		"ease_in"     : [0, _quad], //duplicate of _quad
		"ease_out"    : [1, _quad],
		"ease_in_out" : [2, _quad],
		"ease_out_in" : [3, _quad],
		"ease"        : [2, _quad],
		 
		"quad_in"     : [0, _quad],
		"quad_out"    : [1, _quad],
		"quad_in_out" : [2, _quad],
		"quad_out_in" : [3, _quad],
		"quad"        : [2, _quad],
		 
		"cubic_in"     : [0, _cubic],
		"cubic_out"    : [1, _cubic],
		"cubic_in_out" : [2, _cubic],
		"cubic_out_in" : [3, _cubic],
		"cubic"        : [2, _cubic],
		 
		"quart_in"     : [0, _quart],
		"quart_out"    : [1, _quart],
		"quart_in_out" : [2, _quart],
		"quart_out_in" : [3, _quart],
		"quart"        : [2, _quart],
		 
		"quint_in"     : [0, _quint],
		"quint_out"    : [1, _quint],
		"quint_in_out" : [2, _quint],
		"quint_out_in" : [3, _quint],
		"quint"        : [2, _quint],
		 
		"sine_in"     : [1, _sine],
		"sine_out"    : [0, _sine],
		"sine_in_out" : [3, _sine],
		"sine_out_in" : [2, _sine],
		"sine"        : [3, _sine],
		 
		"expo_in"     : [0, _expo],
		"expo_out"    : [1, _expo],
		"expo_in_out" : [2, _expo],
		"expo_out_in" : [3, _expo],
		"expo"        : [2, _expo],
		 
		"circ_in"     : [0, _circ],
		"circ_out"    : [1, _circ],
		"circ_in_out" : [2, _circ],
		"circ_out_in" : [3, _circ],
		"circ"        : [2, _circ],
		 
		"back_in"     : [0, _back],
		"back_out"    : [1, _back],
		"back_in_out" : [2, _back],
		"back_out_in" : [3, _back],
		"back"        : [1, _back],
		 
		"elastic_in"     : [1, _elastic],
		"elastic_out"    : [0, _elastic],
		"elastic_in_out" : [3, _elastic],
		"elastic_out_in" : [2, _elastic],
		"elastic"        : [0, _elastic],
		 
		"bounce_in"     : [1, _bounce],
		"bounce_out"    : [0, _bounce],
		"bounce_in_out" : [3, _bounce],
		"bounce_out_in" : [2, _bounce],
		"bounce"        : [0, _bounce],
	}
	
	var _interp = _type[$ _ease_type] ?? _type.linear;
	
	switch _interp[0] {
	case 0: //normal
		_amount = _interp[1](_amount);
		break;
	case 1: //reverse
		_amount = 1 - _interp[1](1 - _amount);
		break;
	case 2: //normal-reverse
		_amount = 2 * _amount - 1;
		var _s1 = sign(_amount);
		_amount = 0.5 * (1 - _interp[1](1 - _s1 * _amount)) * _s1 + 0.5;
		break;
	case 3: //reverse-normal
		_amount = 2 * _amount - 1;
		var _s2 = sign(_amount);
		_amount = 0.5 * _interp[1](_s2 * _amount) * _s2 + 0.5;
		break;
	}
	
	return _val1 * (1 - _amount) + _val2 * _amount;
}