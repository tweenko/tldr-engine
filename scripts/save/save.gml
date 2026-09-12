#macro SAVE_FORMAT "save_ch{1}_{0}"
#macro SAVE_FORMAT_COMPLETION "save_ch{1}_{0}.completion"
#macro SAVE_SLOTS 3
#macro SAVE_ENCODE true // if enabled, will encode the saves to base64 before saving them on the player's machine
#macro SAVE_PRETTIFY true // if enabled, the JSON of the save will look be easier to read. will be overriden if saves are encoded

/// @desc set up the save system
function save_init() {
    global.save_slot = global.settings.SAVE_SLOT;
    global.save_recording = [];
    global.save = {};
    global.save_files = [];
}

/// @desc returns a value of a save entry in the currently active save file 
/// @arg {string} _entry_name the name of the entry you'd like to access
/// @arg {any} _failsafe the value the function will return if the save entry does not exist
function save_get(_entry_name, _failsafe = undefined) {
    _entry_name = string_upper(_entry_name);
    
    if struct_exists(global.save, _entry_name)
        return struct_get(global.save, _entry_name);
    return undefined
}
/// @desc sets a value of a save entry in the currently active save file 
/// @arg {string} _entry_name the name of the entry you'd like to set
/// @arg {any} _value the value you want to set the entry's current value to
function save_set(_entry_name, _value) {
    _entry_name = string_upper(_entry_name);
    
    if struct_exists(global.save, _entry_name)
        struct_set(global.save, _entry_name, _value);
}

/// @desc returns whether a save file for a certain slot exists
/// @arg {real} _slot the save slot
/// @arg {real} _chapter the chapter/second specifier of the save file
/// @arg {bool} _in_completion_data whether to look for the save files in completion data instead of normal save files
function save_exists(_slot, _chapter = global.chapter, _in_completion_data = false) {
    var save_file = save_get_file_name(_slot, _chapter, _in_completion_data);
    return file_exists(save_file);
}

/// @desc returns whether a chapter was completed in a certain save slot (refers to `save_exists`)
/// @arg {real} _slot the save slot
/// @arg {real} _chapter the chapter/second specifier of the save file
function save_is_slot_completed(_slot = global.save_slot, _chapter = global.chapter) {
    return save_exists(_slot, _chapter, true);
}

/// @desc returns whether a chapter was completed in any save slot
/// @arg {real} _chapter the chapter/second specifier of the save file
function save_is_chapter_completed(_chapter = global.chapter) {
    for (var i = 0; i < SAVE_SLOTS; i ++) {
        if save_is_slot_completed(i, _chapter)
            return true;
    }
    return false;
}
/// @desc returns whether a chapter has a save file in any slot
/// @arg {real} _chapter the chapter/second specifier of the save file
function save_is_chapter_played(_chapter = global.chapter) {
    for (var i = 0; i < SAVE_SLOTS; i ++) {
        if save_exists(i, _chapter)
            return true;
    }
    return false;
}

/// @desc returns the file name of a save file with a certain slot and chapter
/// @arg {real} _slot
/// @arg {real} _chapter
/// @arg {bool} _completion_file_format
function save_get_file_name(_slot, _chapter = global.chapter, _completion_file_format = false) {
    if _completion_file_format 
        return string(SAVE_FORMAT_COMPLETION, _slot, _chapter);
    return string(SAVE_FORMAT, _slot, _chapter);
}

/// @desc reads the save off the machine
/// @arg {real} _slot the save slot. by default equals to `global.save_slot`
/// @arg {real} _chapter the chapter/second specifier of the save file
/// @arg {bool} _from_completion_data whether to look for the save files in completion data instead of normal save files
function save_read(_slot, _chapter = global.chapter, _from_completion_data = false) {
    if !save_exists(_slot, _chapter, _from_completion_data)
        return -1;
    
    var file = file_text_open_read(save_get_file_name(_slot, _chapter, _from_completion_data));
    var json_data = "";
    
    while (!file_text_eof(file)) 
        json_data += file_text_readln(file);
    file_text_close(file);
    
    return save_from_string(json_data);
}
/// @desc reads all the saves off the machine in a given chapter
function save_read_all(chapter = global.chapter) {
    var arr = [];
    for (var i = 0; i < SAVE_SLOTS; i ++) {
        array_push(arr, save_read(i, chapter));
    }
    
    return arr;
}
/// @desc reads all the completion saves off the machine in a given chapter
function save_read_all_completion(chapter = global.chapter) {
    var arr = [];
    for (var i = 0; i < SAVE_SLOTS; i ++) {
        array_push(arr, save_read(i, chapter, true));
    }
    
    return arr;
}

/// @desc converts save data from raw save data 
/// @arg {struct} _raw_data a struct that `save_read` returns
/// @arg {bool} _to_default_values whether to set all save entries to their default values
function save_convert(_raw_data, _to_default_values = false) {
    var _data = variable_clone(_raw_data);
    if _data == -1
        _data = {};

    for (var i = 0; i < array_length(global.save_recording); i ++) {
        var __recording = global.save_recording[i];
        var __value = (_to_default_values ? variable_clone(__recording.default_value) : variable_clone(struct_get(_data, __recording.name)));
        
        if !_to_default_values
            __value = save_import_variable(variable_clone(struct_get(_data, __recording.name)));
        
        struct_set(_data, string_upper(__recording.name), __value);
    }
    
    return _data;
}
/// @desc loads a save from a certain slot
/// @arg {real} _slot the save slot. by default equals to `global.save_slot`
/// @arg {real} _chapter the chapter/second specifier of the save file
/// @arg {struct} _converted_data the converted data to load. by default just loads the data from the specified slot and chapter
/// @arg {bool} _to_default_values whether to simply load default values specified in the save entries
/// @arg {bool} _from_completion_data whether to look for the save files in completion data instead of normal save files
function save_load(_slot = global.save_slot, _chapter = global.chapter, _data = undefined, _to_default_values = false, _from_completion_data = false) {
    if !save_exists(_slot, _chapter, _from_completion_data) 
        _to_default_values = true;
    
    _data ??= save_convert(save_read(_slot, _chapter, _from_completion_data), _to_default_values);
    
    // call import methods for all save recordings
    for (var i = 0; i < array_length(global.save_recording); i ++) {
        var __recording = global.save_recording[i];
        if is_callable(__recording.__import)
            __recording.__import(struct_get(_data, __recording.name));
    }
    
    global.save = _data;
    global.save_slot = _slot;
    global.chapter = _chapter;
}

/// @desc exports given data into a struct ready to be saved
/// @arg {struct} _data
/// @return {struct}
function save_export(_data = global.save) {
    var _save = variable_clone(_data);
    
    // export everything into the temporary save struct
    for (var i = 0; i < array_length(global.save_recording); i ++) {
        var __recording = global.save_recording[i];
        if is_callable(__recording.__extract)
            struct_set(_save, string_upper(__recording.name), save_export_variable(__recording.__extract()));
    }
    
    return _save;
}
/// @desc saves the game in a certain slot to a file
/// @arg {real} _slot the save slot. by default equals to `global.save_slot`
/// @arg {real} _chapter the chapter/second specifier of the save file
/// @arg {struct} _save_data the save data. by default equals to `save_export()`
/// @arg {bool} _to_completion_file whether the export file should be a completion file
function save_export_to_file(_slot = global.save_slot, _chapter = global.chapter, _save_data = save_export(), _to_completion_file = false) {
    var file_name = save_get_file_name(_slot, _chapter, _to_completion_file);
    var json_data = save_to_string(_save_data);

    var file = file_text_open_write(file_name);
    file_text_write_string(file, json_data);
    file_text_close(file);
    
    if !_to_completion_file
        save_reload();
}
/// @desc saves the game in a completion file that can be loaded in the future. simply refers to `save_export_file` with `to_completion_file` set to true
/// @arg {real} _slot the save slot. by default equals to `global.save_slot`
/// @arg {real} _chapter the chapter/second specifier of the save file
/// @arg {struct} _save_data the save data. by default equals to `save_export()`
function save_export_completion_file(_slot = global.save_slot, _chapter = global.chapter, _save_data = save_export()) {
    return save_export_to_file(_slot, _chapter, _save_data, true);
}

/// @desc erases a save file from a certain slot
/// @arg {real} _slot
/// @arg {real} _chapter
function save_delete(_slot, _chapter = global.chapter) {
    file_delete(save_get_file_name(_slot, _chapter));
    global.save_files[_slot] = {};
    
    if global.save_slot == _slot
        global.save = {};
}

/// @desc reads all the save files from the machine and sets their `global.save_files` counterparts' values to be identical
function save_reload(_chapter = global.chapter) {
    global.save_files = save_read_all(_chapter);
}

/// @desc turns a ready-for-export save file into a string format that can be saved into a file
function save_to_string(_save_data) {
    var _data = json_stringify(_save_data, (!SAVE_ENCODE && SAVE_PRETTIFY));
    if SAVE_ENCODE
        _data = base64_encode(_data);
    
    return _data;
}
/// @desc turns a string input into a raw save file that should be read by `save_convert`
function save_from_string(_string_data) {
    var _data = _string_data;
    if SAVE_ENCODE
        _data = base64_decode(_data);
    
    return json_parse(_data);
}

/// @desc wipe off saves and settings you previously had. irreversible. use sparingly
function save_wipe() {
    // delete saves
    var f = file_find_first(game_save_id + "*", fa_none);
    while f != "" {
        file_delete(game_save_id + f);
        f = file_find_next();
    }
    file_find_close();
}

/// @desc creates completion data for your current save in a certain slot and chapter
function save_complete(_slot = global.save_slot, _chapter = global.chapter) {
    save_export_completion_file(_slot, _chapter);
}
/// @desc erases completion data for a save. not possible to do in DELTARUNE, here for debugging purposes
function save_erase_completion(_slot = global.save_slot, _chapter = global.chapter) {
    if !save_is_slot_completed(_slot, _chapter)
        return false;
    
    var file_name = save_get_file_name(_slot, _chapter, true);
    if file_exists(file_name)
        file_delete(file_name);
}

/// @desc will return the last completed chapter (last chapter that has completion data)
function save_get_last_completed_chapter() {
    var last_completed = 0;
    for (var i = 0; i < array_length(global.registered_chapters); i ++) {
        if save_is_chapter_completed(global.registered_chapters[i].target_chapter)
            last_completed = global.registered_chapters[i].target_chapter;
        else 
            break;
    }
    return last_completed;
}