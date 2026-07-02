/// @desc creates a new save entry and automatically adds it to the save recording global variable
/// @arg {string} _name the name you will use as reference in save_get to retrieve the data
/// @arg {any} _default_value the default value of the entry
/// @arg {function|undefined} _import_method a function the save system will use to import the converted data. argument 0 is the converted data
/// @arg {function|undefined} _extract_method a function the save system will use to extract the raw data. should return what will be converted into saveable data
/// @arg {array<struct>} _target_recording the recording array where the new save entry will be recorded in
/// @arg {array<struct>} _target_struct the struct where the entry's default value will be set
function save_entry(_name, _default_value, _import_method = undefined, _extract_method = undefined, _target_recording = global.save_recording, _target_struct = global.save) {
    var __entry_struct = {
        name: _name,
        default_value: variable_clone(_default_value),
        original_default: variable_clone(_default_value), // this one is here for preserving the original default
        __import: _import_method,
        __extract: _extract_method,
    }
    
    array_push(_target_recording, __entry_struct);
    struct_set(_target_struct, _name, _default_value);
}
/// @desc returns you the default value of a save entry set in the `save_entry` functions
/// @arg {string} _entry_name the name of the save entry
/// @return {any}
function save_entry_get_default(_entry_name) {
    for (var i = 0; i < array_length(global.save_recording); i ++) {
        if string_upper(global.save_recording[i].name) == string_upper(_entry_name) {
            return global.save_recording[i].default_value;
        }
    }
    return undefined;
}
/// @desc changes the default value of a save entry
/// @arg {string} _entry_name the name of the save entry
/// @arg {any} _new_default the new default you'd like the entry to have
function save_entry_set_default(_entry_name, _new_default) {
    for (var i = 0; i < array_length(global.save_recording); i ++) {
        if string_upper(global.save_recording[i].name) == string_upper(_entry_name) {
            global.save_recording[i].default_value = _new_default;
            break;
        }
    }
}
/// @desc resets the default value of a save entry to its original definition
/// @arg {string} _entry_name the name of the save entry
function save_entry_reset_default(_entry_name) {
    for (var i = 0; i < array_length(global.save_recording); i ++) {
        if string_upper(global.save_recording[i].name) == string_upper(_entry_name) {
            global.save_recording[i].default_value = global.save_recording[i].original_default;
            break;
        }
    }
}

/// @desc converts saved variables into a readable format
function save_import_variable(_variable) {
    switch typeof(_variable) {
        default: 
            return _variable;
        case "array":
            var __output_array = [];
            for (var i = 0; i < array_length(_variable); i ++) {
                array_set(__output_array, i, save_import_variable(_variable[i]));
            }
            return __output_array;
        case "struct":
            var __constructable = false;
            if struct_exists(_variable, "_constructor") && struct_exists(_variable, "_data")
                __constructable = true;
            
            if __constructable {
                return save_import_constructed(_variable);
            }
            else {
                var __struct_names = struct_get_names(_variable);
                var __output_struct = {};
                
                for (var i = 0; i < array_length(__struct_names); i ++) {
                    struct_set(__output_struct, __struct_names[i], save_import_variable(struct_get(_variable, __struct_names[i])));
                }
                
                return __output_struct;
            }
    };
};
/// @desc converts any type of variable into a saveable format
function save_export_variable(_variable) {
    switch typeof(_variable) {
        default: 
            return _variable;
        case "array":
            var __output_array = [];
            for (var i = 0; i < array_length(_variable); i ++) {
                array_set(__output_array, i, save_export_variable(_variable[i]));
            }
            return __output_array;
        case "struct":
            if instanceof(_variable) == "struct" {
                var __struct_names = struct_get_names(_variable);
                var __output_struct = {};
                
                for (var i = 0; i < array_length(__struct_names); i ++) {
                    struct_set(__output_struct, __struct_names[i], save_export_variable(struct_get(_variable, __struct_names[i])));
                }
                
                return __output_struct;
            }
            else {
                return save_export_constructed(_variable);
            };
    };
};

/// @desc get a constructed ready for import
function save_import_constructed(_item) {
    if is_undefined(_item)
        return undefined;
    if is_struct(_item) && !struct_exists(_item, "_constructor")
        return _item;
        
    var __scr = asset_get_index(_item._constructor);
    return new __scr(_item._data);
}
/// @desc get a constructed ready for export
function save_export_constructed(_item) {
    if is_undefined(_item)
        return undefined;
    
    var __d = {
        _constructor: instanceof(_item),
        _data: [],
    }
    
    if struct_exists(_item, "_prepare_for_export")
        _item._prepare_for_export();
    if struct_exists(_item, "_data")
        struct_set(__d, "_data", _item._data);
        
    return __d;
}