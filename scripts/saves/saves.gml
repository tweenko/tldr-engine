#macro SAVE_FORMAT "save_ch{1}_{0}"
#macro SAVE_SLOTS 3
#macro SAVE_SETTINGS_FORMAT "settings"

//SAVE
{
	///@arg {real} save
	function save_set(save) {
		global.save_slot = save
	}
	
	///@desc gets data from the LOADED SAVE
	///@arg {string|real} data just use -1 if you want the whole struct
	///@arg {struct} retrieve_from where to get the save data from, gets it from global.save by default
	function save_get(data = -1, retrieve_from = global.save) {
		if data == -1 
            return retrieve_from
		else
			return struct_get(retrieve_from, string_upper(data))
	}
	
	///@desc gets data from the PC SAVE
	///@arg {real} slot save slot
	///@arg {string|real} data just use -1 if you want the whole struct
	///@arg {struct} retrieve_from where to get the save array from, gets it from global.saves by default
	function save_s_get(slot = global.save_slot, data = -1, retrieve_from = global.saves) {
		if data == -1 
            return retrieve_from[slot]
		else
			return struct_get(retrieve_from[slot], string_upper(data))
	}
	
    /// @desc gets the file name of the target save
	function save_get_fname(slot, chapter = global.chapter){
		return string(SAVE_FORMAT,slot, chapter)
	}
    
	///@desc check if a save exists
	///@arg {real} slot -1 if you want to check if any exist
	function save_exists(slot, chapter = global.chapter){
		var txt = save_get_fname(slot, chapter)
		if file_exists(txt)
			return true
		else
			return false
	}
	
	///@desc write in save
	function save_write(slot,data, chapter = global.chapter){
		var save_file = save_get_fname(slot, chapter)
	
		var json_data = json_stringify(data);
	
		var file = file_text_open_write(save_file);
		file_text_write_string(file, json_data);
		file_text_close(file);
	}
	
	///@desc read the save file
	function save_read_all(chapter = global.chapter){
		var arr = []
		for (var i = 0; i < SAVE_SLOTS; ++i) {
			array_push(arr, save_read(i,chapter))
		}
		return arr
	}
	
	///@desc read a save slot
	function save_read(slot, chapter = global.chapter){
		var retst = {}
		var save_file = save_get_fname(slot, chapter)
	
		if (file_exists(save_file)) {
		    var file = file_text_open_read(save_file);
		    var json_data = "";
		    while (!file_text_eof(file)) {
		        json_data += file_text_readln(file);
		    }
		    file_text_close(file);

		    return json_parse(json_data);
		} 
        else
		    return -1
	}
	
	///@desc updates a loaded save
	function save_update_loaded(slot, data){
		global.saves[slot] = data
	}
	
	///@desc updates the save on pc
	function save_update_pc(slot, chapter = global.chapter){
		save_refresh_back()
        
		var data = global.save
		save_update_loaded(slot,data)
		save_write(slot,data,chapter)
		
		save_reload()
	}
	
    ///@desc reload the global.saves variable
	function save_reload(chapter = global.chapter){
		global.saves = save_read_all(chapter)
	}
	
	#macro _save_structs_to_convert [ "weapon", "armor1", "armor2", "spells" ]
    
    ///@desc get ready the party data for import
	function save_party_import(_p_data) {
		for (var i = 0; i < party_getpossiblecount(); ++i) {
			var __d = struct_get(_p_data, struct_get_names(_p_data)[i])
			
			var _arr = _save_structs_to_convert
			for (var j = 0; j < array_length(_arr); ++j) {
				var __cur_cycle = struct_get(__d, _arr[j])
				if is_array(__cur_cycle) { // for the spells
					var __spells = []
					for (var m = 0; m < array_length(__cur_cycle); ++m) { // loop through the spells
						array_push(__spells, save_inv_single_import(__cur_cycle[m])) // import each one
					}
					
					struct_set(__d, _arr[j], __spells)
				}
				else
					struct_set(__d, _arr[j], save_inv_single_import(struct_get(__d, _arr[j])))
			}
		}
		
		return _p_data
	}
	///@desc get ready the party data for export
    function save_party_export(_p_data) {
		_p_data = deep_clone(_p_data)
		
		for (var i = 0; i < party_getpossiblecount(); ++i) {
			var __d = struct_get(_p_data, struct_get_names(_p_data)[i])
			var __dp = struct_get(global.party, struct_get_names(_p_data)[i])
			
			var _arr = _save_structs_to_convert
			for (var j = 0; j < array_length(_arr); ++j) {
				var __cur_cycle = struct_get(__d, _arr[j])
				var __cur_cycle_p = struct_get(__dp, _arr[j])
				
				if is_array(__cur_cycle) { // for the spells
					var __spells = []
					for (var m = 0; m < array_length(__cur_cycle); ++m) { // loop through the spells
						array_push(__spells, save_inv_single_export(__cur_cycle_p[m])) // import each one
					}
					
					struct_set(__d, _arr[j], __spells)
				}
				else
					struct_set(__d, _arr[j], save_inv_single_export(struct_get(__dp, _arr[j])))
			}
		}
		
		return _p_data
	}
	
    ///@desc get an item ready for import
	function save_inv_single_import(_item) {
		if is_undefined(_item)
			return undefined
		if is_struct(_item) && !struct_exists(_item, "_constructor") // for the items that are defined pre-laod (party spells)
			return _item
			
		var __scr = asset_get_index(_item._constructor)
		return new __scr(_item._data)
	}
    ///@desc get an item ready for export
	function save_inv_single_export(_item) {
		if is_undefined(_item)
			return undefined
		
		var __d = {
			_constructor: instanceof(_item),
			_data: [],
		}
		if struct_exists(_item, "_data")
			struct_set(__d, "_data", _item._data)
			
		return __d 
	}
	
    ///@desc get the inventory ready for import
	function save_inv_import(arr){
		var ret = []
		for (var i = 0; i < array_length(arr); ++i) {
			array_push(ret, save_inv_single_import(arr[i]))
		}
		return ret
	}
    ///@desc get the inventory ready for export
	function save_inv_export(arr){
		var ret = []
		
		for (var i = 0; i < array_length(arr); ++i) {
			array_push(ret, save_inv_single_export(arr[i])) 
		}
		
		return ret
	}
	
    ///@desc load a save
	function save_load(slot, chapter = global.chapter) {
		music_stop_all()
		
		if global.saves[slot] != -1 
            global.save = global.saves[slot]
        
        global.lw_weapon = save_inv_single_import(save_get("lw_weapon"))
        global.lw_armor = save_inv_single_import(save_get("lw_armor"))
		
		global.chapter = chapter
		save_set(slot)
		
		global.items = save_inv_import(save_get("items"))
		global.key_items = save_inv_import(save_get("key_items"))
		global.weapons = save_inv_import(save_get("weapons"))
		global.armors = save_inv_import(save_get("armors"))
		global.storage = save_inv_import(save_get( "storage"))
		global.lw_items = save_inv_import(save_get("lw_items"))
		
		global.time = save_get("time")
		global.party_names = save_get("party_names")
		global.party = save_party_import(save_get("party_data"))
		global.states = save_get("states")
		global.world = save_get("world")
		
		save_refresh_back()
	}
	///@desc refreshes the back-loaded save
    function save_refresh_back() {
		global.save.PARTY_DATA = save_party_export(global.party)
		global.save.PARTY_NAMES = global.party_names
		global.save.STATES = global.states
		global.save.CHAPTER = global.chapter
		global.save.TIME = global.time
		
        global.save.LW_WEAPON = save_inv_single_export(global.lw_weapon)
        global.save.LW_ARMOR = save_inv_single_export(global.lw_armor)
        
		global.save.ITEMS = save_inv_export(global.items)
		global.save.KEY_ITEMS = save_inv_export(global.key_items)
		global.save.WEAPONS = save_inv_export(global.weapons)
		global.save.ARMORS = save_inv_export(global.armors)
		global.save.STORAGE = save_inv_export(global.storage)
		global.save.LW_ITEMS = save_inv_export(global.lw_items)
		
		global.save.WORLD = global.world
	}
	
	///@desc delete a save slot from the machine
	function save_delete(slot, chapter = global.chapter){
		file_delete(save_get_fname(slot, chapter))
	}
    
    /// @desc wipe off saves and settings you previously had. irreversible. use sparingly
    function save_wipe() {
        var fileName = file_find_first("", 0);
        while fileName != "" {
            file_delete(fileName)
            fileName = file_find_next();
        }
        file_find_close();
    }
}

//SETTINGS
{
    ///@desc check whether the settings file exists
	function save_settings_exists(){
		return file_exists(SAVE_SETTINGS_FORMAT)
	}
	
    ///@desc update the current settings accordingly on the computer
	function save_settings_update() {
		save_settings_refresh()
	
		var f = file_text_open_write(SAVE_SETTINGS_FORMAT)
		var s = json_stringify(global.settings)
		
        file_text_write_string(f, s)
        
		file_text_close(f)
	}
	
    ///@desc returns the whole settings struct from the local machine
	function save_settings_read() {
		var f = file_text_open_read(SAVE_SETTINGS_FORMAT)
		var ret = ""
		while !file_text_eof(f) {
			ret += file_text_read_string(f)
			file_text_readln(f)
		}
		file_text_close(f)
	
		ret = json_parse(ret)
		return ret
	}
	
    /// @desc updates the save slot variable in the settings (in the back-loaded settings)
	function save_settings_refresh(){
		global.settings.SAVE_SLOT = global.save_slot
        
        global.settings.VOL_MASTER = o_world.volume_master
        global.settings.VOL_SFX = o_world.volume_sfx
        global.settings.VOL_BGM = o_world.volume_bgm
        
        global.settings.CONTROLS_KEY = InputBindingsExport(false)
        global.settings.CONTROLS_GP = InputBindingsExport(true)
        
        global.settings.LANG = global.loc_lang
        global.settings.VERSION_SAVED = ENGINE_VERSION
	}
    
    ///@desc loads the settings from the device into global.settings
	function save_settings_load() {
		if save_settings_exists() {
			global.settings = save_settings_read()
            
            o_world.volume_master = global.settings.VOLUME_MASTER
            o_world.volume_sfx = global.settings.VOLUME_SFX
            o_world.volume_bgm = global.settings.VOLUME_BGM
            
            if struct_exists(global.settings, "CONTROLS_KEY")
                InputBindingsImport(false, global.settings.CONTROLS_KEY)
            if struct_exists(global.settings, "CONTROLS_GP")
                InputBindingsImport(true, global.settings.CONTROLS_GP)
            
            if struct_exists(global.settings, "LANG")
                global.loc_lang = global.settings.LANG
		}
	}
		
	///@desc delete the settings file
	function save_settings_delete(){
		file_delete(SAVE_SETTINGS_FORMAT)
	}
}