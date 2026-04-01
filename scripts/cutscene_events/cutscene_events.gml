/// @desc a constructor for an event during a cutscene
/// @arg {function} _call what will be executed when the cutscene calls for the event
/// @arg {function} _resume_condition the condition, when it returns `true`, will flick pause to false and resume the cutscene
/// @arg {function} _step a method that will be called every frame while the event is ongoing
/// @arg {function} _finish a method that will be called once the event has finished
function cutscene_event(_call, _resume_condition = undefined, _step = undefined, _finish = undefined) constructor {
    call = _call;
    
    step = _step;
    finish = _finish;
    
    resume_condition = _resume_condition;
    
    destroy = function() {
        if !is_undefined(finish)
            method_call(finish);
    }
}




/// @desc shows a debug message during a cutscene
/// @arg {string} _message the debug message to display
function cutscene_debug_message(_message) {
    cutscene_queue_event(
        cutscene_get_current(), 
        new cutscene_event(method(
            {_message}, 
            function() {
                show_debug_message(string(_message));
            }
        ))
    );
}

/// @desc pauses the cutscene for a certain amount of frames
/// @arg {real} frames the length of the pause
function cutscene_sleep(_frames) {
    var event = new cutscene_event(undefined);
    event.frames = _frames;
    
    event.resume_condition = method(event, function() {
        return frames <= 0;
    })
    event.step = method(event, function() {
        frames --;
    })
    
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
}
/// @desc pauses the cutscene until the resume condition is met
/// @arg {function} resume_condition the method that should return true for the cutscene to continue
/// @arg {array} arguments the arguments you'd like to feed into the function
function cutscene_wait_until(resume_condition, arguments = []) {
	var event = new cutscene_event(undefined, method({resume_condition, arguments}, function() {
        return method_call(resume_condition, arguments);
    }));
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
}
/// @desc sets a variable of an instance during a cutscene
/// @arg {Id.Instance|Asset.GMObject} instance the instance, the variable of which you'd like to change
/// @arg {string} variable_name the name of the variable that you'd like to change
/// @arg {any} value the value you'd like to change the value of the variable to
function cutscene_set_variable(instance, variable_name, value) {
	var event = new cutscene_event(method({instance, variable_name, value}, function() {
        variable_instance_set(instance, variable_name, value)
    }));
    
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
}
/// @desc creates an instance during a cutscene
function cutscene_instance_create(obj, xx = 0, yy = 0, ddepth = 0, post_var_struct = {}) {
    var event = new cutscene_event(method({obj, xx, yy, ddepth, post_var_struct}, function() {
        instance_create(obj, xx, yy, ddepth, post_var_struct);
    }));
    
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
}
/// @desc plays a sound during a cutscene
function cutscene_audio_play(sound, loop = 0, gain = 1, pitch = 1, nonstack = false) {
    var event = new cutscene_event(
        method({sound, loop, gain, pitch, nonstack}, function() {
			audio_play(sound, loop, gain, pitch, nonstack);
		})
    );
    
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
}

/// @desc runs a function during a cutscene
/// @arg {function} func
function cutscene_func(func, args = []) { 
    var event = new cutscene_event(method({func, args}, function() {
        if !is_array(args) 
            args = [args]
        method_call(func, args)
    }));
    
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
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
function cutscene_anim(val1, val2, frames, ease_type, call_method) {
    var event = new cutscene_event(method({val1, val2, frames, ease_type, call_method}, function() {
        call_method(val1)
        anime_tween(val1, val2, frames, ease_type, call_method)
    }));
    
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
}

/// @desc	cutscene_anim but has automatic instance existance checking as well as direct instance adressing. 
///         The cutscene will not wait for the animation to end.
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
function cutscene_animate(val1, val2, frames, ease_type, inst, var_name) {
    var event = new cutscene_event(method({val1, val2, frames, ease_type, inst, var_name}, function() {
        animate(val1, val2, frames, ease_type, inst, var_name)
    }));
    
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
}




/// @desc set whether the player is allowed to move
function cutscene_player_canmove(can_move) {
    var event = new cutscene_event(method({can_move}, function() {
        global.player_moveable_global = can_move;
    }));
    
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
}
/// @desc set whether the party members are following the leader
function cutscene_party_follow(follow) {
    var event = new cutscene_event(method({follow}, function() {
        party_setfollow(follow);
    }));
    
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
}




/// @desc runs dialogue in a cutscene and waits until the dialogue box is destroyed if asked to
/// @arg {string|array<string>} dialogue could be either an array or just a string. if it's an array, between the array entries the box will pause and clear itself afterwards.
/// @arg {string} postfix the string added to the end of the text typer. "{p}{e}" by default
/// @arg {bool} wait whether the cutscene should wait until the dialogue is destroyed
/// @arg {undefined|bool} box_pos_down whether the box should be forced down (true), up (false) or automatic (undefined, the default)
/// @arg {bool} destroy_other_instances whether the dialogue should destroy the other already existing dialogue instances before spawning itself
function cutscene_dialogue(dialogue, postfix = "{p}{e}", wait = true, box_pos_down = undefined, _destroy_other_instances = true) {
	var event = new cutscene_event(undefined);
    
    event._dialogue = dialogue_array_to_string(dialogue);
    event._postfix = postfix;
    event._wait = wait;
    event._box_pos_down = box_pos_down;
    event._destroy_other_instances = _destroy_other_instances;
    event._inst_dialogue = noone;
    
    event.call = method(event, function() {
        if _destroy_other_instances
            instance_destroy(o_ui_dialogue);
        
        _inst_dialogue = instance_create(o_ui_dialogue, 0, 0, 0, {text: _dialogue, postfix: _postfix});
        if !is_undefined(_box_pos_down)
            _inst_dialogue._reposition_self_to(_box_pos_down);
    });
    
    event.resume_condition = (wait 
        ? method(event, function() {return !instance_exists(_inst_dialogue)}) 
        : undefined
    );
    
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
}
/// @desc creates a speech bubble stemming from an actor instance
/// @arg {string|array<string>} dialogue could be either an array or just a string. if it's an array, between the array entries the box will pause and clear itself afterwards.
/// @arg {Id.Instance|Asset.GMObject} actor_inst the actor instance the bubble will stem from
/// @arg {string} prefix the string added to the beginning of the text typer. "" by default
/// @arg {string} postfix the string added to the end of the text typer. "{p}{e}" by default
/// @arg {bool} wait whether the cutscene should wait until the dialogue is destroyed
/// @arg {enum.ACTORDIALOGUE_SIDE} coming_from what side the bubble will be coming from. `ACTORDIALOGUE_SIDE.FROM_LEFT` by default
function cutscene_actor_dialogue(dialogue, actor_inst, prefix = "", postfix = "{p}{e}", wait = true, coming_from = ACTORDIALOGUE_SIDE.FROM_LEFT) {
    var event = new cutscene_event(undefined);
    
    event._dialogue = dialogue;
    event._actor_inst = actor_inst;
    event._prefix = prefix;
    event._postfix = postfix;
    event._wait = wait;
    event._coming_from = coming_from;
    event._inst_dialogue = noone;
    
    event.call = method(event, function() {
        _inst_dialogue = actor_dialogue_create(_dialogue, _actor_inst, _prefix, _postfix,,,,, _coming_from);
    });
    
    event.resume_condition = (wait 
        ? method(event, function() {return !instance_exists(_inst_dialogue)}) 
        : undefined
    );
    
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
}

/// @desc pauses the cutscene until a certain amount of dialogue boxes has been seen
// /@arg {real} boxes_to_wait_for
function cutscene_wait_dialogue_boxes(boxes_to_wait_for) {
    var event = new cutscene_event(
        function() {
            global.cutscene_wait_dialogue_boxes_initial = undefined;
        }, 
        method({boxes_to_wait_for}, function() {
            if !instance_exists(o_text_typer) 
                return false;
    
            if is_undefined(global.cutscene_wait_dialogue_boxes_initial)
                global.cutscene_wait_dialogue_boxes_initial = o_text_typer.current_box;
                
            var _boxes = o_text_typer.current_box - global.cutscene_wait_dialogue_boxes_initial;
            return _boxes >= boxes_to_wait_for;
        })
    );
    
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
}
/// @desc pauses the cutscene until the dialogue box is destroyed
function cutscene_wait_dialogue_finish() {
    var event = new cutscene_event(
        undefined, 
        function() {
			return !instance_exists(o_ui_dialogue);
		}
    )
    
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
}




/// @desc  move an actor during a cutscene
/// @param {Id.Instance,Asset.GMObject} target the actor to move
/// @param {array<struct.actor_movement>} movement the movement struct based on actor_movement
/// @param {bool} [wait] whether to wait until this is all done or not
function cutscene_actor_move(target, movement, wait = true) {
    var event = new cutscene_event(undefined);
    
    event._target = target;
    event._movement = movement;
    event._mover_inst = noone;
    
    event.call = method(event, function() {
        _mover_inst = actor_move(_target, _movement);
    })
    event.resume_condition = (wait 
        ? method(event, function() {return !instance_exists(_mover_inst)}) 
        : undefined
    );
    
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
}
/// @desc interpolates the party members' positions to be a part of the caterpillar. often used at the end of cutscenes with `cutscene_party_follow(true)`
function cutscene_party_interpolate() {
    var event = new cutscene_event(
        function() {
			for (var i = 0; i < party_length(true); ++i) {
			    party_member_interpolate(global.party_names[i]);
			}
		}
    );
    
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
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
    var event = new cutscene_event(
        method({x_dest, y_dest, time, ease_type, confined_x, confined_y}, function() {
            camera_pan(x_dest, y_dest, time, ease_type, confined_x, confined_y)
        })
    );
    event.time = time;
    event.timer = 0;
    
    event.step = method(event, function() {
        timer ++;
    });
    event.resume_condition = (wait 
        ? method(event, function() {
            return timer > time
        })
        : undefined
    )
    
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
};
/// @desc sets a party member's sprite accordingly to the battle sprites struct from party_data
/// @arg {string} party_name party member name
/// @arg {Asset.GMSprite|string} sprite_ref the sprite to use. can be either a string that will be put into `enc_getparty_sprite` or a sprite index
/// @arg {real} index the image index of the sprite, by default doesn't change it
/// @arg {real} speed the speed of the sprite, by default doesn't change it
function cutscene_set_partysprite(party_name, sprite_ref, image_index = undefined, image_speed = undefined) {
    var event = new cutscene_event(
        method({party_name, sprite_ref, _image_index: image_index, _image_speed: image_speed}, function() {
            enc_party_set_battle_sprite(party_name, sprite_ref, _image_index, _image_speed)
        })
    );
    cutscene_queue_event(
        cutscene_get_current(), 
        event
    );
};




/// @desc checks whether a cutscene event is valid
/// @arg {struct.cutscene_event} _event the event to check
/// @returns {bool}
function cutscene_event_isvalid(_event) {
    return is_struct(_event) && is_instanceof(_event, cutscene_event)
}