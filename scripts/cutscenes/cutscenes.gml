/// @desc a constructor for a new cutscene instance
/// @arg {bool} _local whether to destroy the cutscene when leaving the room
function cutscene(_local = true) constructor {
    queue = [];
    playing = false;
    time_source = undefined;
    local = _local;
    
    start_room = undefined;
    
    current_event = undefined;
    
    play = function() {
        // call for the first time
        method(self, callback)
        
        start_room = room;
        
        // and loop
        time_source = call_later(1, time_source_units_frames, method(self, callback), true);
    }
    
    callback = function() {
        // don't perform callback if we left the start room and we're local
        if local && start_room != room {
            destroy();
            return false;
        }
        
        if !is_undefined(current_event) {
            if !is_undefined(current_event.resume_condition) && is_callable(current_event.resume_condition) && method_call(current_event.resume_condition) {
                current_event.destroy();
                delete current_event;
                current_event = undefined;
            }
            else if !is_undefined(current_event.step) && is_callable(current_event.step)
                method_call(current_event.step);
        }
        
        // loop through the coming queue
        while is_undefined(current_event) {
            if array_length(queue) == 0 {
                destroy();
                return false;
            }
            
            current_event = queue[0];
            array_delete(queue, 0, 1);
            
            if !is_undefined(current_event.call) && is_callable(current_event.call)
                method_call(current_event.call);
            
            // instantly check if the resume condition is met or undefined
            if is_undefined(current_event.resume_condition)
                || (!is_undefined(current_event.resume_condition) && is_callable(current_event.resume_condition) && method_call(current_event.resume_condition))
            {
                current_event.destroy();
                delete current_event;
                current_event = undefined;
            }
        }
    };
    destroy = function() {
        if time_source_exists(time_source)
            call_cancel(time_source);
        time_source = undefined;
        
        return false;
    }
}

/// @desc returns the current cutscene instance stored in `global.current_cutscene`
function cutscene_get_current() {
	return global.current_cutscene;
}
/// @desc sets the `global.current_cutscene` to the instance provided
/// @arg {struct.cutscene} _cutscene
function cutscene_set_current(_cutscene) {
	global.current_cutscene = _cutscene;
}

/// @desc creates a cutscene instance.
/// @arg {bool} _local whether to destroy the cutscene when leaving the room
/// @arg {bool} _autoset whether `global.current_cutscene` should be set to this newly created cutscene struct
/// @return {struct.cutscene}
function cutscene_create(_local = true, _autoset = true) {
    var inst = new cutscene(_local);
    
	if _autoset
		cutscene_set_current(inst);
	return inst;
}

/// @desc plays a given cutscene (if not given one, plays `global.current_cutscene` as long as it's valid)
/// @arg {struct.cutscene} _cutscene the cutscene struct to play
function cutscene_play(_cutscene = global.current_cutscene) {
    if !cutscene_isvalid()
        return false
    
    method_call(_cutscene.play)
}
/// @desc stops a given cutscene (if not given one, plays `global.current_cutscene` as long as it's valid)
 /// @arg {struct.cutscene} _cutscene the cutscene struct to stop
function cutscene_stop(_cutscene = global.current_cutscene) {
    if !cutscene_isvalid()
        return false
    
    method_call(_cutscene.destroy);
}

/// @desc adds a cutscene event to the tail of the current cutscene queue
/// @arg {struct.cutscene} cutscene the instance of the cutscene you'd like to add the event to
/// @arg {struct.cutscene_event} event the event you'd like to queue
function cutscene_queue_event(_cutscene = global.current_cutscene, _event = undefined) {
    if cutscene_event_isvalid(_event) && cutscene_isvalid(_cutscene) {
        array_push(_cutscene.queue, _event)
    }
}

/// @desc check whether the cutscene instance is valid
function cutscene_isvalid(_cutscene = global.current_cutscene) {
	if is_struct(_cutscene) && is_instanceof(_cutscene, cutscene)
		return true;
	return false;
}