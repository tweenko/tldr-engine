/// @desc returns a certain memory identifier in a certain memory category
/// @arg {string} _category the category of the target memory (ex. `"boxes"`)
/// @arg {any*} _identificator the identificator of the target memory (ex. `inst_A1292B`)
/// @returns {any*}
function memory_get(_category, _identificator) {
    _identificator = string(_identificator)
    
    if !struct_exists(global.memories, _category)
        return undefined;
    
    var __category_struct = struct_get(global.memories, _category);
	if !struct_exists(__category_struct, _identificator)
        return undefined;
    
    return struct_get(__category_struct, _identificator);
}

/// @desc sets a certain memory identificator to a value. returns whether the target memory was changed or not
/// @arg {string} _category the category of the target memory (ex. `"boxes"`)
/// @arg {any*} _identificator the identificator of the target memory (ex. `inst_A1292B`)
/// @arg {any*} _value the value you'd like to set the memory to
/// @arg {bool} _locked if this is set to true, if the target memory already exists and is not set to undefined, it will not be changed.
/// @returns {bool}
function memory_set(_category, _identificator, _value, _locked = false) {
    _identificator = string(_identificator)
    
    if !struct_exists(global.memories, _category)
        struct_set(global.memories, _category, {});
    
    var __category_struct = struct_get(global.memories, _category);
	if (struct_exists(__category_struct, _identificator) || struct_get(__category_struct, _identificator) != undefined) && _locked
        return false;
    
    struct_set(__category_struct, _identificator, _value);
    struct_set(global.memories, _category, __category_struct);
    
    return true;
}

/// @desc flicks a memory. if the memory doesn't exist, it will be flicked to true. returns the new value of the memory
/// @arg {string} _category the category of the target memory (ex. `"boxes"`)
/// @arg {any*} _identificator the identificator of the target memory (ex. `inst_A1292B`)
/// @arg {bool} _locked if this is set to true, if the target memory already exists and is not set to undefined, it will not be changed.
/// @returns {bool}
function memory_flick(_category, _identificator, _locked = false) {
    _identificator = string(_identificator)
    
    if !struct_exists(global.memories, _category)
        struct_set(global.memories, _category, {});
    
    var __category_struct = struct_get(global.memories, _category);
	if struct_exists(__category_struct, _identificator) && _locked
        return true;
    
    if !struct_exists(__category_struct, _identificator)
        struct_set(__category_struct, _identificator, false);
    
    struct_set(__category_struct, _identificator, (!struct_get(__category_struct, _identificator)));
    struct_set(global.memories, _category, __category_struct);
    
    return struct_get(__category_struct, _identificator);
}

/// @desc removes a certain memory identificator entirely
/// @arg {string} _category the category of the target memory (ex. `"boxes"`)
/// @arg {any*} _identificator the identificator of the target memory (ex. `inst_A1292B`)
function memory_remove(_category, _identificator) {
    if !struct_exists(global.memories, _category)
        return false;
    
    // remove the memory
    struct_remove(struct_get(global.memories, _category), string(_identificator))
}