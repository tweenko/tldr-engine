#macro SAVE_SETTINGS_FORMAT "settings"

/// @desc set up the save settings system
function save_settings_init() {
    global.save_settings_recording = [];
    global.settings = {};
}

/// @desc returns a value of a setting save entry
/// @arg {string} _entry_name the name of the entry you'd like to access
/// @arg {any} _failsafe the value the function will return if the save entry does not exist
function save_settings_get(_entry_name, _failsafe = undefined) {
    _entry_name = string_upper(_entry_name)
    
    if struct_exists(global.settings, _entry_name)
        return struct_get(global.settings, _entry_name)
    return undefined
}
/// @desc sets a value of a setting save entry
/// @arg {string} _entry_name the name of the entry you'd like to set
/// @arg {any} _value the value you want to set the entry's current value to
function save_settings_set(_entry_name, _value) {
    _entry_name = string_upper(_entry_name)
    
    if struct_exists(global.settings, _entry_name)
        struct_set(global.settings, _entry_name, _value)
}

/// @desc returns whether a settings file exists
function save_settings_exist() {
    return file_exists(SAVE_SETTINGS_FORMAT)
}

/// @desc reads the settings save off the machine
function save_settings_read() {
    if !save_settings_exist()
        return {};
    
    var file = file_text_open_read(SAVE_SETTINGS_FORMAT);
    var json_data = "";
    
    while (!file_text_eof(file)) 
        json_data += file_text_readln(file);
    file_text_close(file);
    
    return save_from_string(json_data);
}

/// @desc converts settings save data from raw save data 
/// @arg {struct} _raw_data a struct that `save_read` returns
/// @arg {bool} _to_default_values whether to set all save entries to their default values
function save_settings_convert(_raw_data, _to_default_values = false) {
    var _data = variable_clone(_raw_data);

    for (var i = 0; i < array_length(global.save_settings_recording); i ++) {
        var __recording = global.save_settings_recording[i];
        var __value = (_to_default_values ? variable_clone(__recording.default_value) : variable_clone(struct_get(_data, __recording.name)));
        
        if !_to_default_values && is_callable(__recording.__convert)
            __value = __recording.__convert(variable_clone(struct_get(_data, __recording.name)));
        
        struct_set(_data, string_upper(__recording.name), __value);
    }
    
    return _data;
}
/// @desc loads a settings save
/// @arg {struct} _converted_data the converted data to load. by default just loads the available settings data
/// @arg {bool} _to_default_values whether to simply load default values specified in the settings save entries
function save_settings_load(_data = undefined, _to_default_values = false) {
    if !save_settings_exist()
        _to_default_values = true;
    
    _data ??= save_settings_convert(save_settings_read(), _to_default_values);
    
    // call import methods for all save recordings
    for (var i = 0; i < array_length(global.save_settings_recording); i ++) {
        var __recording = global.save_settings_recording[i];
        if is_callable(__recording.__import)
            __recording.__import(struct_get(_data, __recording.name));
    }
    
    global.settings = _data;
}

/// @desc exports all current settings data into a struct
/// @return {struct}
function save_settings_export() {
    var _save = variable_clone(global.settings);
    
    // export everything into the temporary save struct
    for (var i = 0; i < array_length(global.save_settings_recording); i ++) {
        var __recording = global.save_settings_recording[i];
        if is_callable(__recording.__export)
            struct_set(_save, string_upper(__recording.name), __recording.__export());
    }
    
    return _save;
}
/// @desc saves the game settings to a file
/// @arg {struct} _settings_data the save data. by default equals to `save_settings_export()`
function save_settings_export_to_file(_settings_data = save_settings_export()) {
    var file_name = SAVE_SETTINGS_FORMAT;
    var json_data = save_to_string(_settings_data);

    var file = file_text_open_write(file_name);
    file_text_write_string(file, json_data);
    file_text_close(file);
}