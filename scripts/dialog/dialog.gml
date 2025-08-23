///@desc starts dialogue
///@arg {array<string>,string} text 
///could be either an array or just a string. if it's an array, between the array entries the box will pause and clear itself afterwards.
function dialogue_start(text) {
	var inst = instance_create(o_ui_dialogue)
	text = dialogue_array_to_string(text)
	inst.text = text
	
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