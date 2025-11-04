///@desc	Creates a new animation with a starting position. Use the built-in methods to edit and run the animation.
///@param {Real} start_val		The first value of the animation
///@return {Struct.__anime_class}
function create_anime(start_val) {
	return new __anime_class(start_val);
}

///@desc	Animates a value between two positions along a single curve.
///			For built-in easing set ease_type to a string, or for custom easing use a function,
///			animation curve struct or ID, or animation curve channel.
///@param {Real} val1				The first value of the animation
///@param {Real} val2				The last value of the animation
///@param {Real} frames				The duration in frames
///@param {String|Function|Struct|Asset.GMAnimCurve} ease_type
///									The easing curve
///@param {Function} call_method	The method to call for each frame of animation
///@param {Array} args	Arguments you want to pass to call_method
///@return {Struct.__anime_class}
function do_anime(val1, val2, frames, ease_type, call_method, args = []) {
	var a = create_anime(val1)
	.add(val2, frames, ease_type)
	.start(call_method, args)
	
	return a
}

///@desc	do_anime but has automatic instance existance checking as well as direct instance adressing
///			For built-in easing set ease_type to a string, or for custom easing use a function,
///			animation curve struct or ID, or animation curve channel.
///@param {Real} val1				The first value of the animation
///@param {Real} val2				The last value of the animation
///@param {Real} frames				The duration in frames
///@param {String|Function|Struct|Asset.GMAnimCurve} ease_type
///									The easing curve
///@param {Id.Instance} inst	The instance to animate
///@param {string} var_name	The name of the variable to animate
///@return {Struct.__anime_class}
function do_animate(val1, val2, frames, ease_type, inst, var_name) {
	return do_anime(val1, val2, frames, ease_type, function(v, inst, vn) {
		if instance_exists(inst) 
			variable_instance_set(inst, vn, v)
		}, [inst, var_name]
	)
}

///@ignorex
function __anime_class(start_val) constructor {
	///@return {Struct.__anime_class}
	static add = function(val, frames, ease_type = "linear") {
		if (frames < 1) {
			show_message("ANIME: Frames cannot be less than 1.")
			return self;
		}
		array_push(data, {
			val : val,
			frames : frames,
			type :  ease_type
		});
		return self;
	}
	
	///@desc	Enables or disables looping. Use stop() to exit looping animations.
	///@param {Bool} [do_loop]	Whether to loop (defaults to true)
	///@return {Struct.__anime_class}
	static loop = function(_loop = true) {
		doLoop = _loop;
		return self;
	}
	
	///@desc	Sets the call method. In most cases this is not needed as one can be set with start()
	///@param {Function} call_method	The method to call for each frame of animation
	///@return {Struct.__anime_class}
	static set_method = function(_call_method) {
		_func = _call_method;
		return self;
	}
	
	///@desc	Starts the animation (or unpauses if previously paused).
	///@param {Function} [call_method]	Optionally set the call method if one was not set previously
	///@param {Array} args	Bonus Arguments for the method
	///@return {Struct.__anime_class}
	static start = function(call_method = func, args=[]) {
		if (array_length(data) = 0) return self;
		arg = args
		if !is_array(arg) 
			arg = [arg]
		
		index = -1;
		x2 = xStart;
		nextData();
		func = call_method;
		if (!is_method(func)) {
			show_message("ANIME: Cannot start without call method.");
			return self;
		}
		callback();
		stop();
		timeSource = call_later(1, time_source_units_frames, callback, true);
		return self;
	}
	
	///@desc	Pauses the animation. Use start() to unpause.
	///@return {Struct.__anime_class}
	static pause = function() {
		if (_time_source != -1) {
			call_cancel(_time_source);
			_time_source = -1;
		}
		return self;
	}
	
	///@desc	Stops the animation.
	///@return {Struct.__anime_class}
	static stop = function() {
		if (timeSource != -1) {
			call_cancel(timeSource);
			timeSource = -1;
		}
        
		return self;
	}
	
	///@desc	Returns a duplicate copy of the animation. Useful for running multiple of an animation simultaneously.
	///@return {Struct.__anime_class}
	static clone = function() {
		var _len = array_length(_data);
		var _new_data = array_create(_len);
		array_copy(_new_data, 0, _data, 0, _len);
		return new __anime_class(_x_start, _do_loop, _func, _new_data);
	}

	
	/**@ignore*/ static nextData = function() {
		index ++;
		if (index >= array_length(data)) {
			if doLoop {
				index = 0;
				x2 = xStart;
			} else {
				return false;
			}
		}
		var dat = data[index];
		x1 = x2;
		x2 = dat.val;
		frame = 0;
		maxFrames = dat.frames;
		type = dat.type;
		return true;
	}
	
	/**@ignore*/ callback = function() {
		frame ++;
		var val = frame / maxFrames;
		if is_method(func){
			method_call(func, array_concat([lerp_type(x1, x2, val, type)], arg))
		};
		if (val >= 1) {
			if (!nextData()){
				stop();
				finished=true
			}
		}
	}
	
	/**@ignore*/ xStart = start_val;
	/**@ignore*/ x1 = start_val;
	/**@ignore*/ x2 = start_val;
	/**@ignore*/ frame = 0;
	/**@ignore*/ maxFrames = 1;
	/**@ignore*/ type = "";
	/**@ignore*/ func = undefined;
	/**@ignore*/ doLoop = false;
	/**@ignore*/ finished = false
	
	/**@ignore*/ data = [];
	/**@ignore*/ index = -1;
	/**@ignore*/ timeSource = -1;
}