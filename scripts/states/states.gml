/// @desc STATES are just shelves where you can put things on. 
/// you can only check if the thing is there and cannot set its value, and the same thing cannot be added twice.
/// this particular command allows you to fill a state slot if it's not yet been added
/// 
/// @arg {string} type the type of state you want to work with
/// @arg {real|string|any*} identificator the id of the slot you will fill. the id should be able to turn into a hash, so no functions or such variable types.

function state_add(type, identificator = id) {
	if !struct_exists(global.states, type)
        struct_set(global.states, type, [])
	if !state_get(type, identificator) 
        array_push(struct_get(global.states, type), identificator)
}

/// @desc STATES are just shelves where you can put things on. 
/// you can only check if the thing is there and cannot set its value, and the same thing cannot be added twice.
/// this particular command allows you to retrieve whether the state slot is filled or not
/// 
/// @arg {string} type the type of state you want to work with
/// @arg {real|string|any*} identificator the id of the slot you will fill. the id should be able to turn into a hash, so no functions or such variable types.

function state_get(type, identificator = id){
	var ret = false
	if struct_exists(global.states, type) 
		ret = array_contains(struct_get(global.states, type), identificator)
	return ret
}