/// @desc a constructor for a new cutscene instance
function cutscene() constructor {
    queue = [];
    playing = false;
    time_source = undefined;
    
    current_event = undefined;
    
    play = function() {
        // call for the first time
        method(self, callback)
        
        // and loop
        time_source = call_later(1, time_source_units_frames, method(self, callback), true);
    }
    
    callback = function() {
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
/// @arg {string} unique_id the id the cutscene will be referred to as during debugging. optional to set
/// @arg {bool} autoset whether `global.current_cutscene` should be set to this newly created cutscene struct
/// @return {struct.cutscene}
function cutscene_create(unique_id = "untitled_cutscene", autoset = true) {
    var inst = new cutscene(unique_id);
    
	if autoset
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