/// @desc creates an `o_ui_dialogue` instance with set parameters
/// @arg {array<string>,string} text could be either an array or just a string. if it's an array, between the array entries the box will pause and clear itself afterwards.
/// @arg {bool} destroy_other_instances whether the dialogue should destroy the other already existing dialogue instances before spawning itself
/// @arg {bool} allow_movement whether the player can move or not during the dialogue
function dialogue_start(text, _destroy_other_instances = true, allow_movement = false) {
    if _destroy_other_instances
        instance_destroy(o_ui_dialogue)
    
	var inst = instance_create(o_ui_dialogue)
	inst.text = dialogue_array_to_string(text)
    
    get_leader().moveable_dialogue = allow_movement
	
	return inst
}

///@arg {array<string>, string} arr
function dialogue_array_to_string(arr) {
	if is_string(arr) 
		return arr
	
	var str = ""
	for (var i = 0; i < array_length(arr); ++i) {
	    str += arr[i]
		if i < array_length(arr)-1 
			str += "{p}{c}"
	}
	return str
}