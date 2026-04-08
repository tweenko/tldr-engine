/// @desc returns a certain state identifier in a certain state category
/// @arg {string} _category the category of the target state (ex. `"boxes"`)
/// @arg {any*} _identificator the identificator of the target state (ex. `inst_A1292B`)
/// @returns {any*}
function state_get(_category, _identificator) {
    if !struct_exists(global.states, _category)
        return undefined
    
    var __category_struct = struct_get(global.states, _category)
    
	if !struct_exists(__category_struct, _identificator)
        return undefined
    
    return struct_get(__category_struct, _identificator)
}

/// @desc sets a certain state identificator to a value. returns whether the target state was changed or not
/// @arg {string} _category the category of the target state (ex. `"boxes"`)
/// @arg {any*} _identificator the identificator of the target state (ex. `inst_A1292B`)
/// @arg {any*} _value the value you'd like to set the state to
/// @arg {bool} _locked if this is set to true, if the target state already exists and is not set to undefined, it will not be changed.
/// @returns {bool}
function state_set(_category, _identificator, _value, _locked = false) {
    if !struct_exists(global.states, _category)
        struct_set(global.states, _category, {})
    
    var __category_struct = struct_get(global.states, _category)
	if (struct_exists(__category_struct, _identificator) || struct_get(__category_struct, _identificator) != undefined) && _locked
        return false
    
    struct_set(__category_struct, _identificator, _value)
    struct_set(global.states, _category, __category_struct)
    
    return true
}
/// @desc flicks a state. if the state doesn't exist, it will be flicked to true. returns the new value of the state
/// @arg {string} _category the category of the target state (ex. `"boxes"`)
/// @arg {any*} _identificator the identificator of the target state (ex. `inst_A1292B`)
/// @arg {bool} _locked if this is set to true, if the target state already exists and is not set to undefined, it will not be changed.
/// @returns {bool}
function state_flick(_category, _identificator, _locked = false) {
    if !struct_exists(global.states, _category)
        struct_set(global.states, _category, {})
    
    var __category_struct = struct_get(global.states, _category)
	if struct_exists(__category_struct, _identificator) && _locked
        return true
    
    if !struct_exists(__category_struct, _identificator)
        struct_set(__category_struct, _identificator, false)
    
    struct_set(__category_struct, _identificator, (!struct_get(__category_struct, _identificator)))
    struct_set(global.states, _category, __category_struct)
    
    return struct_get(__category_struct, _identificator)
}