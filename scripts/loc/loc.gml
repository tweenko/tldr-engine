#macro LOC_LANG_LIST [ "en", "ja" ]

global.loc_source = {}
global.loc_source_fallback = {}

global.loc_lang = "en"
global.loc_fallback_lang = "en"
global.loc_dir = "loc/"
global.loc_files = []

var fileName = file_find_first(global.loc_dir + "*.json", 0);
while fileName != "" {
    array_push(global.loc_files, fileName);
    fileName = file_find_next();
}
file_find_close();

function loc_fname_format(fname) {
	return global.loc_dir + fname
}

/// @desc loads all the specified files
/// @arg {string} lang
function loc_load(lang = global.loc_lang) {
    for (var i = 0; i < array_length(global.loc_files); ++i) {
        var fname = loc_fname_format(global.loc_files[i])

        if file_exists(fname) {
            var f = file_text_open_read(fname)
		    var content = ""
        
		    while !file_text_eof(f){
		        content += file_text_readln(f)
		    }
			
			var tstruct = json_parse(content)
			var tnms = struct_get_names(tstruct)
			
			for (var j = 0; j < array_length(tnms); ++j) {
				struct_set(global.loc_source, tnms[j], struct_get(struct_get(tstruct, tnms[j]), lang))
				struct_set(global.loc_source_fallback, tnms[j], struct_get(struct_get(tstruct, tnms[j]), global.loc_fallback_lang))
			}
			
            file_text_close(f)
        }
		else
            loc_error($"Localization file \"{fname}\" was not found.", true)
    }
}

///@desc used to localize strings by finding the same one in the localization file
///@arg {string} loc_id the id of the localized text you want to get
function loc(loc_id) {
	if struct_exists(global.loc_source, loc_id)
		return struct_get(global.loc_source, loc_id)
    if struct_exists(global.loc_source_fallback, loc_id)
        return struct_get(global.loc_source_fallback, loc_id)
		
	return loc_id
}
/// @desc used to localize strings by finding the same one in the localization file while also functioning as the `string` function in terms of being able to replace bracketed parts of the localized string (supports infinite arguments)
/// @arg {string} loc_id the id of the localized text you want to get
/// @arg {string,real} replacements a value you'd like to replace the corresponding bracketed part of the localized string with
/// @arg {string,real} ...
/// @arg {string,real} ...
/// @arg {string,real} ...
/// @arg {string,real} ...
function loc_string(loc_id, replacement0 = "", replacement1 = "", replacement2 = "", replacement3 = "", replacement4 = "") {
	if struct_exists(global.loc_source, loc_id) {
        loc_id = struct_get(global.loc_source, loc_id)
        return string(loc_id, replacement0, replacement1, replacement2, replacement3, replacement4)
    }
    if struct_exists(global.loc_source_fallback, loc_id) {
        loc_id = struct_get(global.loc_source_fallback, loc_id)
        return string(loc_id, replacement0, replacement1, replacement2, replacement3, replacement4)
    }
		
	return loc_id
}
///@desc used to localize sprites. if unable to do so, spr_default will be returned
///@arg {string} loc_id the id of the localized sprite you want to get
function loc_sprite(loc_id) {
    if struct_exists(global.loc_source, loc_id)
		return asset_get_index(struct_get(global.loc_source, loc_id))
    if struct_exists(global.loc_source_fallback, loc_id)
        return asset_get_index(struct_get(global.loc_source_fallback, loc_id))
		
	return spr_default
}
///@desc used to localize fonts
///@arg {string} font_id the id of the localized font you want to get
function loc_font(font_id){
    var _loc_id = "font_" + font_id
    if struct_exists(global.loc_source, _loc_id)
        return asset_get_index(loc(_loc_id))
    if struct_exists(global.loc_source_fallback, _loc_id)
        return asset_get_index(loc(_loc_id))
    
	return font_main
}

function loc_error(err_text = "Undefined", critical = false) {
	show_error(string(" \nLOCALIZATION ERROR:\n{0}\n ", err_text), critical)
}

function loc_getlang() {
	return global.loc_lang
}

/// @desc switches the current language
/// @arg {string} lang if undefined, will just switch to the next available language option
/// @arg {bool} load_save whether to load the last available save
function loc_switch_lang(lang = undefined, load_save = true) {
	if is_undefined(lang) {
		var __cur = array_get_index(LOC_LANG_LIST, global.loc_lang)
		global.loc_lang = LOC_LANG_LIST[(__cur + 1) % array_length(LOC_LANG_LIST)]
	}
	else
		global.loc_lang = lang
	
	loc_load()
    with o_world
        event_user(0)
    
    if load_save {
        music_stop_all();
        
        global.saves = save_read_all() // saves saved on device
        if global.saves[global.save_slot] != -1 
            global.save = global.saves[global.save_slot]
        save_load(global.save_slot);
        
        room_goto(save_get("room"));
    }
}