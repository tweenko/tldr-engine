/// @desc creates a new save entry and automatically adds it to the save recording global variable
/// @arg {string} _name the name you will use as reference in save_get to retrieve the data
/// @arg {any} _default_value the default value of the entry
/// @arg {function|undefined} _import_method a function the save system will use to import the converted data. argument 0 is the converted data (or raw data if `_convert_method` is undefined), should return nothing and set the variable in it
/// @arg {function|undefined} _export_method a function the save system will use to export the raw data. should return what will be stored in the hash
/// @arg {function|undefined} _convert_method a method the save system will use to convert the raw data into converted data that will be fed into the `_import_method`
/// @arg {array<struct>} _target_recording the recording array where the new save entry will be recorded in
/// @arg {array<struct>} _target_struct the struct where the entry's default value will be set
function save_entry(_name, _default_value, _import_method = undefined, _export_method = undefined, _convert_method = undefined, _target_recording = global.save_recording, _target_struct = global.save) {
    var __entry_struct = {
        name: _name,
        default_value: variable_clone(_default_value),
        original_default: variable_clone(_default_value), // this one is here for preserving the original default
        __import: _import_method,
        __export: _export_method,
        __convert: _convert_method,
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

/// @desc get a struct ready for import
/// @arg {struct} _struct the raw struct to import
/// @arg {array<string>} _need_import hashes of the struct that require `save_import_constructed`
function save_import_struct(_struct, _need_import = []) {
    _struct = variable_clone(_struct);
    
    var _struct_names = struct_get_names(_struct)
    for (var i = 0; i < array_length(_struct_names); ++i) {
        var __d = struct_get(_struct, _struct_names[i]);
        
        var _arr = _need_import
        for (var j = 0; j < array_length(_need_import); ++j) {
            var __cur_cycle = struct_get(__d, _need_import[j]);
            if is_array(__cur_cycle) { // for the arrays
                var __spells = [];
                for (var m = 0; m < array_length(__cur_cycle); ++m) { // loop through the array
                    array_push(__spells, save_import_constructed(__cur_cycle[m])); // import each one
                }
                
                struct_set(__d, _need_import[j], __spells);
            }
            else
                struct_set(__d, _need_import[j], save_import_constructed(struct_get(__d, _need_import[j])));
        }
    }
    
    return _struct;
}
/// @desc get a struct ready for export
/// @arg {struct} _struct the raw struct to export
/// @arg {array<string>} _need_export hashes of the struct that require `save_export_constructed`
function save_export_struct(_struct, _need_export = []) {
    var _struct_original = _struct;
    _struct = variable_clone(_struct);
    
    var _struct_names = struct_get_names(_struct);
    for (var i = 0; i < array_length(_struct_names); ++i) {
        var __d = struct_get(_struct, _struct_names[i]);
        var __dp = struct_get(_struct_original, struct_get_names(_struct_original)[i]);
        
        for (var j = 0; j < array_length(_need_export); ++j) {
            var __cur_cycle = struct_get(__d, _need_export[j]);
            var __cur_cycle_p = struct_get(__dp, _need_export[j]);
            
            if is_array(__cur_cycle) { // for the arrays
                var __spells = [];
                for (var m = 0; m < array_length(__cur_cycle); ++m) { // loop through the array
                    array_push(__spells, save_export_constructed(__cur_cycle_p[m])); // export each one, and use the orginal struct to preserve the constructed's instance
                }
                
                struct_set(__d, _need_export[j], __spells);
            }
            else
                struct_set(__d, _need_export[j], save_export_constructed(struct_get(__dp, _need_export[j]))); // use the orginal struct to preserve the constructed's instance
        }
    }
    
    return _struct;
}

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

///@desc get the inventory ready for import
function save_import_constructed_array(arr){
    var ret = [];
    for (var i = 0; i < array_length(arr); ++i) {
        array_push(ret, save_import_constructed(arr[i]));
    }
    return ret;
}
///@desc get the inventory ready for export
function save_export_constructed_array(arr){
    var ret = [];
    for (var i = 0; i < array_length(arr); ++i) {
        array_push(ret, save_export_constructed(arr[i]));
    }
    return ret;
}