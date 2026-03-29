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

/// @desc checks whether a cutscene event is valid
/// @arg {struct.cutscene_event} _event the event to check
/// @returns {bool}
function cutscene_event_isvalid(_event) {
    return is_struct(_event) && is_instanceof(_event, cutscene_event)
}