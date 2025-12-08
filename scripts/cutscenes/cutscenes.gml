///@desc returns the current cutscene instance stored in global.current_cutscene
function cutscene_get() {
	return global.current_cutscene
}

///@desc creates a cutscene instance. if needed, also sets global.current_cutscene to the newly created one.
function cutscene_create(autoset = true) {
    var inst = instance_create(o_cutscene_inst)
    
	if autoset
		cutscene_set(inst)
	return inst
}

///@desc sets the current cutscene to the instance provided
/// @arg {Id.Instance} _cutscene
function cutscene_set(_cutscene) {
	global.current_cutscene = _cutscene
}

///@desc check whether the cutscene instance is valid
function cutscene_isvalid(_cutscene = global.current_cutscene) {
	if instance_exists(_cutscene) && _cutscene.object_index = o_cutscene_inst
		return true
	return false
}

///@desc	a custom cutscene event
///         --------
///			these variables are allowed to be included in the **_custom struct**:
///			**action** *(array - function, arg0, arg1...)* - the action to perform upon the event's start
///			**continue_func** *(function)* - the function that is run to check whether the cutscene may resume or not. must return boolean
///			**continue_args** *(array)* - the arguments that are passed onto continue_func
///         **pause** *(bool)* - whether to pause the cutscene (if there is a continue_func, if you will)

///@arg		{struct}	_custom 
function cutscene_custom(_custom = {
		action: [],
		
		continue_func: function(){
			return true
		},
		continue_args: [],
    
        pause: false,
	}
){
	if !cutscene_isvalid(global.current_cutscene)
		exit
	if struct_exists(_custom, "action") 
		ds_queue_enqueue(global.current_cutscene.actions, _custom.action)
	if struct_exists(_custom, "continue_args") 
		ds_queue_enqueue(global.current_cutscene.actions, [variable_instance_set, global.current_cutscene, "continue_args", _custom.continue_args]);
	if struct_exists(_custom, "continue_func") 
		ds_queue_enqueue(global.current_cutscene.actions, [variable_instance_set, global.current_cutscene, "continue_func", _custom.continue_func]);
	if struct_exists(_custom, "pause") 
            && _custom.pause
        || struct_exists(_custom, "continue_func") 
    		&& struct_exists(_custom, "continue_args") 
            && !script_execute_ext(_custom.continue_func, _custom.continue_args)
	{
		ds_queue_enqueue(global.current_cutscene.actions, [variable_instance_set, global.current_cutscene, "sleep", -1])
	}
}

///@desc starts the cutscene (playing the queue in order)
function cutscene_play() {
	if instance_exists(global.current_cutscene) 
		global.current_cutscene.play = true
}

// cutscene presets

///@desc pauses the queue of the cutscene to the set amount of frames
function cutscene_sleep(sleep) {
	cutscene_custom({
		sleep,
		action: [variable_instance_set, global.current_cutscene, "sleep", sleep]
	})
}

///@desc runs dialogue in a cutscene and waits until the dialogue box is destroyed if asked to
///@arg {string|array<string>} dialogue
///could be either an array or just a string. if it's an array, between the array entries the box will pause and clear itself afterwards.
function cutscene_dialogue(dialogue, postfix = "{p}{e}", wait = true, box_pos_down = undefined) {
	dialogue = dialogue_array_to_string(dialogue)
    
	cutscene_custom({
		dialogue,
		wait,
		postfix,
        box_pos_down,

		action: [function(dialogue, postfix, box_pos_down) {
            var inst = instance_create(o_ui_dialogue, 0, 0, 0, {text: dialogue, postfix})
            if !is_undefined(box_pos_down)
                inst._reposition_self_to(box_pos_down)
        }, dialogue, postfix, box_pos_down],

		continue_func: function(wait) {
			return (wait ? !instance_exists(o_ui_dialogue) : true)
		},
		continue_args: [wait],
		pause: wait,
	})
}

///@desc pauses the cutscene until a certain amount of dialogue boxes has been seen
///@arg {real} boxes_to_wait_for
function cutscene_wait_dialogue_boxes(boxes_to_wait_for) {
	cutscene_custom({
		pause: true,
		
		boxes_to_wait_for: boxes_to_wait_for,
		
		action: [function() {
			global.cutscene_wait_dialogue_boxes_initial = undefined
		}],
		continue_func: function(__amt) {
			if !instance_exists(o_text_typer) return false

			if is_undefined(global.cutscene_wait_dialogue_boxes_initial)
				global.cutscene_wait_dialogue_boxes_initial = o_text_typer.current_box
				
			var _boxes = o_text_typer.current_box - global.cutscene_wait_dialogue_boxes_initial
			return _boxes >= __amt
		},
		continue_args: [boxes_to_wait_for],
	})
}

///@desc pauses the cutscene until the dialogue box is destroyed
function cutscene_wait_dialogue_finish() {
	cutscene_custom({
		pause: true,
		continue_func: function() {
			return !instance_exists(o_ui_dialogue)
		},
	})
}

///@desc set whether the player is allowed to move
function cutscene_player_canmove(move) {
	cutscene_custom({
		move,
		action: [function(move) {
            global.player_moveable_global = move
        }, move],
	})
}

///@desc set whether the party members are following the leader
function cutscene_party_follow(follow){
	cutscene_custom({
		follow : follow,
		action: [function(follow){
			party_setfollow(follow)
		}, follow],
	})
}

/// @desc  move an actor during a cutscene
/// @param {Id.Instance,Asset.GMObject} target the actor to move
/// @param {array<struct.actor_movement>} movement the movement struct based on actor_movement
/// @param {real} [pos] the array index of global.charmove_insts. needed only if there are multiple of these running at once
/// @param {bool} [wait] whether to wait until this is all done or not
function cutscene_actor_move(target, movement, pos = 0, wait = true) {
	cutscene_custom({
		target,
		movement,
        pos: pos,
        wait: wait,
		
		action: [function(target, movement, wait, pos) {
            actor_move(target, movement, pos)
        }, target, movement, wait, pos],
		continue_func: function(wait, pos) {
            if !wait
                return true
			return is_undefined(global.charmove_insts[pos])
		},

		continue_args: [wait, pos],
		pause: wait,
	})
}

/// @desc plays a sound during a cutscene
function cutscene_audio_play(sound, loop = 0, gain = 1, pitch = 1, nonstack = false) {
	cutscene_custom({
		sound, loop, gain, pitch, nonstack,
		action: [audio_play, sound, loop, gain, pitch, nonstack],
	})
}

/// @desc interpolates the party member's positions to be a part of the caterpillar
function cutscene_party_interpolate(){
	cutscene_custom({
		action: [function(){
			for (var i = 0; i < array_length(global.party_names); ++i) {
			    party_member_interpolate(global.party_names[i])
			}
		}],
	})
}

/// @desc pauses the cutscene until the continue function returns true
function cutscene_wait_until(continue_func = function(){return true}, continue_args = []) {
	cutscene_custom({
		pause: true,
		continue_func,
		continue_args,
	})
}

/// @desc sets a variable of an object during a cutscene
function cutscene_set_variable(obj, variable, value) {
	cutscene_custom({
		obj, variable, value,
		action: [variable_instance_set, obj, variable, value]
	})
}

/// @desc sets a party member's sprite accordingly to the battle sprites struct from party_data
function cutscene_set_partysprite(selection, spritename ){
	var set = function(selection, spritename) {
		party_get_inst(global.party_names[selection]).sprite_index = enc_getparty_sprite(selection, spritename)
		party_get_inst(global.party_names[selection]).image_index = 0
		party_get_inst(global.party_names[selection]).image_speed = 1
	}
	cutscene_custom({
		selection, spritename, set,
		action: [set, selection, spritename]
	})
}

/// @desc	Animates a value between two positions along a single curve during a cutscene
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
function cutscene_anim(val1, val2, frames, ease_type, call_method, array = []){
	cutscene_custom({
		val1, val2, frames, ease_type, call_method, array,
		action: [anime_tween, val1, val2, frames, ease_type, call_method, array]
	})
}

/// @desc	cutscene_anim but has automatic instance existance checking as well as direct instance adressing
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
function cutscene_animate(val1, val2, frames, ease_type, inst, var_name){
	cutscene_custom({
		val1, val2, frames, ease_type, inst, var_name,
		action: [animate, val1, val2, frames, ease_type, inst, var_name]
	})
}

/// @desc creates an instance during a cutscene
function cutscene_instance_create(obj, xx = 0, yy = 0, ddepth = 0, post_var_struct = {}){
	cutscene_custom({
		obj, xx, yy, ddepth, post_var_struct,
		action: [instance_create, obj, xx, yy, ddepth, post_var_struct]
	})
}

/// @desc runs a function during a cutscene
/// @arg {function} func the function to be run
function cutscene_func(func, args = []){ 
	cutscene_custom({
		func, args,
		action: [function(func,args) {
			if !is_array(args) 
				args = [args]
			script_execute_ext(func, args)
		}, func, args]
	})
}

/// @desc pan the camera using two animation instances during a cutscene
/// @param {real} x_dest  set to undefined if you don't want to move on this axis
/// @param {real} y_dest  set to undefined if you don't want to move on this axis
/// @param {real} time the amount of time the camera will take to fully animate
/// @param {bool} wait whether the cutscene should be paused until the camera reaches its destination
/// @param {string} [ease_type] the ease type the animation will use, look in lerp_type script to find the full list
/// @param {bool} [confined_x] whether the camera is confined within the bounds of the room on the x axis (true by default)
/// @param {bool} [confined_y] whether the camera is confined within the bounds of the room on the y axis (true by default)
function cutscene_camera_pan(x_dest, y_dest, time, wait = true, ease_type = "linear", confined_x = true, confined_y = true) {
    var data = {
        x_dest: x_dest,
        y_dest: y_dest,
        time: time,
        wait: wait,
        ease_type: ease_type,
        confined_x, confined_y,
        
        timer: 0,
        action: [camera_pan, x_dest, y_dest, time, ease_type, confined_x, confined_y]
    };

    // First arg is the struct itself
    data.continue_func = function(_data, _wait, _time) {
        _data.timer ++
        if !_wait
            return true
        
        return _data.timer > _time
    }
    data.continue_args = [data, wait, time]

    cutscene_custom(data);
}