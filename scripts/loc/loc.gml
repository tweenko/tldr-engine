#macro LOC_FILES [ "config.json", "general.json", "ui.json", "txt.json" ] 
#macro LOC_LANG_LIST [ "en", "jp" ]

global.loc_source = {}
global.loc_dir = "loc/"
global.loc_lang = "en"

function loc_fname_format(fname){
	return global.loc_dir + fname
}

///@desc loads all the specified files
///@arg {array<string>} files
function loc_load(files, lang = global.loc_lang) {
    for (var i = 0; i < array_length(files); ++i) {
        var fname = loc_fname_format(files[i])

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
			}
			
            file_text_close(f)
        }
		else {
            loc_error($"Localization file \"{fname}\" was not found.", true)
        }
    }
}

///@desc used to localize strings by finding the same one in the localization file
///@arg {string} loc_id the id of the localized text you want to get
function loc(loc_id) {
	if struct_exists(global.loc_source, loc_id)
		return struct_get(global.loc_source, loc_id)
		
	return loc_id
}

function loc_error(err_text = "Undefined", critical = false) {
	show_error(string(" \nLOCALIZATION ERROR:\n{0}\n ", err_text), critical)
}

function loc_getfont(font_id){
	return asset_get_index(loc("font_"+font_id))
}

function loc_getlang() {
	return global.loc_lang
}
	
function loc_switch_lang(lang = undefined) {
	if is_undefined(lang) {
		var __cur = array_get_index(LOC_LANG_LIST, global.loc_lang)
		global.loc_lang = LOC_LANG_LIST[(__cur + 1) % array_length(LOC_LANG_LIST)]
	}
	else
		global.loc_lang = lang
	
	loc_load(LOC_FILES)
}