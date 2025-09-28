function item() constructor {
	name = ["Item"] // short, then long (first is default)
	desc = ["Overworld Description", "Battle Text", "Shop Description"] // ow, battle, shop
	type = ITEM_TYPE.CONSUMABLE
	
	lw_counterpart = undefined // reference a script, nothing appears in the light world if it's undefined
	
	// item specific
	use_type = ITEM_USE.INDIVIDUAL
	can_use = true // false if cant
	throw_scripts = {
		can: true,
		execute_code: function() { //executes this INSTEAD of the default item_delete
		},
	}
	
	// equippable specific
	stats = {
		attack: 0,
		defense: 0,
		magic: 0,
		element_resistance: {
		}, // out of 1
	}
    stats_misc = {} // money_modifier
    
	effect = undefined // (struct with the sprite key and text key)
	icon = spr_ui_menu_icon_exclamation
	
	weapon_fatal = false
	weapon_whitelist = []
	armor_blacklist = []
	
	// spell specific
	tp_cost = 0
	color = c_white
	is_party_act = false
	is_mercyspell = false // does it allow to spare enemies?
	
	reactions = {
	}
	use = -1
	use_args = []
	
	shop = {
	}
}

enum ITEM_TYPE {
	CONSUMABLE,
	KEY,
	WEAPON,
	ARMOR,
	SPELL,
	STORAGE,
	LIGHT
}
enum ITEM_USE {
	INDIVIDUAL,
	EVERYONE,
	ENEMY,
}

///@desc returns the maximum amount of items you can hold depending on the item type
function item_get_maxcount(type = ITEM_TYPE.CONSUMABLE) {
	if type == ITEM_TYPE.CONSUMABLE
		return 12
	if type == ITEM_TYPE.STORAGE
		return 24
	
	return 48
}

///@desc deletes an item according to its type
function item_delete(item_slot, type = ITEM_TYPE.CONSUMABLE) {
	if type == ITEM_TYPE.STORAGE
		item_get_array(type)[item_slot] = undefined
	else 
		array_delete(item_get_array(type), item_slot, 1)
}

///@desc adds an item to your inventory, returns the text you get upon obtaining the item
///@return {string}
function item_add(item_struct, type = ITEM_TYPE.CONSUMABLE) {
	var can = true
	
	if struct_exists(item_struct, "type") && type == 0
		type = item_struct.type
	if type == ITEM_TYPE.CONSUMABLE {
		if item_get_count(type) >= item_get_maxcount(type) {
			if item_get_count(ITEM_TYPE.STORAGE) < item_get_maxcount(ITEM_TYPE.STORAGE)
				type = ITEM_TYPE.STORAGE
			else 
				can = false
		}
	}
	else
		if item_get_count(type) >= item_get_maxcount(type) 
			can = false
	
	var txt = string(loc("item_added"), item_get_name(item_struct), item_get_store_name(type))
	if can {
		if type == ITEM_TYPE.STORAGE {
			var i = 0
			for (i = 0; i < array_length(item_get_array(ITEM_TYPE.STORAGE)); ++i) {
				if item_get_array(ITEM_TYPE.STORAGE)[i] != undefined 
					break
			}
			item_set(item_struct, i, type)
		}
		else
			array_push(item_get_array(type), item_struct)
	}
	else
		txt = loc("item_added_no_space")
	
	return txt
}

///@desc replaces an item in the array
function item_set(item_struct, index, type = ITEM_TYPE.CONSUMABLE) {
	if index >= item_get_count(type) && type != ITEM_TYPE.STORAGE
		index = item_get_count(type)
	array_set(item_get_array(type), index, item_struct)
}

///@desc calls the item's use method
function item_use(item_struct, index, target) {
    if is_undefined(item_struct)
        return undefined
	if is_callable(item_struct.use) {
		if !is_array(item_struct.use_args) 
			item_struct.use_args = [item_struct.use_args]
		script_execute_ext(item_struct.use, array_concat([index, target, id], item_struct.use_args))
	}
}

///@desc returns the amount of a specific item type in the inventory
function item_get_count(type = ITEM_TYPE.CONSUMABLE){
	var ret = 0
	var a = item_get_array(type)
	for (var i = 0; i < array_length(a); ++i) {
		if a[i] != undefined 
			ret ++
	}
	return ret
}

///@desc returns the name of an item
function item_get_name(item_struct) {
    if is_undefined(item_struct)
        return undefined
	var ret = item_struct.name
	
	if is_array(ret)
		return ret[0]
	if is_string(ret)
		return ret
    return undefined
}

///@desc returns the description of an item
///@arg item_struct the struct of the item
///@arg desc_type the type of the description that will be returned (0 for full, 1 for shortened)
function item_get_desc(item_struct, desc_type = 0){
    if is_undefined(item_struct)
        return undefined
	var ret = item_struct.desc
	
	if is_array(ret)
		return ret[desc_type]
	if is_string(ret)
		return ret
}

///@desc returns the type of an item
function item_get_type(item_struct) {
    if is_undefined(item_struct)
        return undefined
	return item_struct.type
}

///@desc returns whether the item can deal fatal damage to the enemies
function item_get_fatal(item_struct) {
	if is_undefined(item_struct) 
        return false
	if struct_exists(item_struct, "weapon_fatal") && item_struct.weapon_fatal
		return true
    
    return false
}

///@desc returns the item array depending on the type
///@return array
function item_get_array(type){
	switch(type) {
		case ITEM_TYPE.CONSUMABLE:
			return global.items
		case ITEM_TYPE.KEY:
			return global.key_items
		case ITEM_TYPE.WEAPON:
			return global.weapons
		case ITEM_TYPE.ARMOR:
			return global.armors
		case ITEM_TYPE.STORAGE:
			return global.storage
		case ITEM_TYPE.LIGHT:
			return global.lw_items
	}
}

///@desc returns the storage name
function item_get_store_name(type){
	switch(type) {
		case ITEM_TYPE.CONSUMABLE:
			return loc("item_type_items")
		case ITEM_TYPE.KEY:
			return loc("item_type_key_items")
		case ITEM_TYPE.WEAPON:
			return loc("item_type_weapons")
		case ITEM_TYPE.ARMOR:
			return loc("item_type_armors")
		case ITEM_TYPE.STORAGE:
			return loc("item_type_storage")
		case ITEM_TYPE.LIGHT:
			return loc("item_type_items")
	}
}

///@desc used only for the dark world overworld menu, activates the party's reactions to an item
///@arg name
///@arg {string|struct} reaction
function item_menu_party_react(name, reaction) {
	if is_struct(reaction) {
		for (var i = 0; i < array_length(global.party_names); ++i) {
			if struct_exists(reaction, global.party_names[i]) {
				var u = party_getpos(global.party_names[i])
				
				o_ui_menu.partyreaction[u] = struct_get(reaction, global.party_names[i])
				o_ui_menu.partyreactiontimer[u] = o_ui_menu.partyreactionlen
			}
		}
	}
	else {
		var user = party_getpos(name)
		
		o_ui_menu.partyreaction[user] = reaction
		o_ui_menu.partyreactiontimer[user] = o_ui_menu.partyreactionlen
	}
}

///@desc calls item_menu_party_react while extracting the reaction from the item struct. only used in the dark world overworld menu
function item_menu_reaction(item_struct, user = 0) {
	if item_struct.use_type == 0 {
		var reaction = struct_get(item_struct.reactions, global.party_names[user])
		item_menu_party_react(global.party_names[user], reaction)
	}
	else {
		for (var i = 0; i < array_length(global.party_names); ++i) {
			var reaction = struct_get(item_struct.reactions, global.party_names[i])
			item_menu_party_react(global.party_names[i], reaction)
		}
	}
}

///@desc checks whether the item is within the inventory
function item_contains(item_struct){
	var s = item_get_array(item_struct.type)
	
	for (var i = 0; i < array_length(s); ++i) {
		if !is_undefined(s[i])
			continue
		if instanceof(item_struct) == instanceof(s[i]) 
			return i
	}
	
	return undefined
}

///@desc check whether an item is equipped. returns the COUNT of matching items found
///@arg {Asset.GMScript,struct} _item_ref the item constructor OR item struct that we are looking a match for
///@arg {string} _party_name check a specific party member to have the item equipped
///@return {real,undefined}
function item_get_equipped(_item_ref, _party_name = undefined) {
	var __item = (is_struct(_item_ref) ? _item_ref : new _item_ref())
	var __iteminst = (is_struct(_item_ref) ? instanceof(_item_ref) : script_get_name(_item_ref))
	
	var __equipped = 0
	if is_undefined(_party_name) {
		for (var i = 0; i < array_length(global.party_names); ++i) {
			if __item.type == 2 {
				var __a = party_getdata(global.party_names[i], "weapon")
				if !is_undefined(__a) && instanceof(__a) == __iteminst
					__equipped ++
			}
			else if __item.type == 3 {
				var __a = party_getdata(global.party_names[i], "armor1")
				if !is_undefined(__a) && instanceof(__a) == __iteminst
					__equipped ++
					
				var __b = party_getdata(global.party_names[i], "armor2")
				if !is_undefined(__b) && instanceof(__b) == __iteminst
					__equipped ++
			}
		}
	}
	else {
		if !party_ismember(_party_name) {
			show_debug_message($"item_get_equipped: \"{_party_name}\" not found in global.party_names")
			return 0
		}
		
		if __item.type == 2 {
			var __a = party_getdata(_party_name, "weapon")
			if !is_undefined(__a) && instanceof(__a) == __iteminst
				__equipped ++
		}
		else if __item.type == 3 {
			var __a = party_getdata(_party_name, "armor1")
			if !is_undefined(__a) && instanceof(__a) == __iteminst
				__equipped ++
					
			var __b = party_getdata(_party_name, "armor2")
			if !is_undefined(__b) && instanceof(__b) == __iteminst
				__equipped ++
		}
	}
	
	return __equipped
}

/// @desc check whether a spell exists. returns the COUNT of matching spells found
/// @arg {Asset.GMScript,struct} the item constructor OR item struct that we are looking a match for
/// @arg {string} _party_name check a specific party member to have the spell, otherwise checks everybody
/// @return {real,undefined}
function item_spell_get_exists(_item_ref, _party_name = undefined) {
    var __iteminst = (is_struct(_item_ref) ? instanceof(_item_ref) : script_get_name(_item_ref))
    
    var __spells_found = 0
    if is_undefined(_party_name) {
        for (var i = 0; i < array_length(global.party_names); ++i) {
			__spells_found = item_spell_get_index(_item_ref, global.party_names[i])
            if !is_undefined(__spells_found)
                break
		}
    }
    else
        __spells_found = item_spell_get_index(_item_ref, _party_name)
    
    if is_undefined(__spells_found)
        return false
    else 
        return true
}

/// @desc returns the struct of a spell that matches
/// @arg {Asset.GMScript,struct} _item_ref the item constructor OR item struct that we are looking a match for
/// @arg {string} _party_name check a specific party member to have the spell
/// @return {struct.item|undefined}
function item_spell_get_struct(_item_ref, _party_name) {
    var ret = undefined
    var __spell_index = item_spell_get_index(_item_ref, _party_name)
    
    if is_undefined(__spell_index)
        return undefined
    return party_getdata(_party_name, "spells")[__spell_index]
}

/// @desc returns the INDEX of the spell
/// @arg {Asset.GMScript,struct} _item_ref the item constructor OR item struct that we are looking a match for
/// @arg {string} _party_name check a specific party member to have the spell
/// @return {real,undefined}
function item_spell_get_index(_item_ref, _party_name) {
    var __iteminst = (is_struct(_item_ref) ? instanceof(_item_ref) : script_get_name(_item_ref))
    
    var __index = undefined
    if !party_ismember(_party_name) {
        show_debug_message($"item_spell_get_index: \"{_party_name}\" not found in global.party_names")
        return undefined
    }
    for (var j = 0; j < array_length(party_getdata(_party_name, "spells")); j ++) {
        var __a = party_getdata(_party_name, "spells")[j]
        if !is_undefined(__a) && instanceof(__a) == __iteminst {
            __index = j
            break
        }
    }
    
    return __index
}

/**
 * re-creates the struct with new data
 * @param {string} _party_name the name of the party member who's spell we want to reload
 * @param {real} _spell_index the index of the spell to reload
 * @param {struct|undefined} [_data] the data you pass to the constructor when reloading
 */
function item_spell_reload(_party_name, _spell_index, _data = undefined) {
    var __iteminst = asset_get_index(instanceof(party_getdata(_party_name, "spells")[_spell_index]))
    var _n = undefined
    
    if !is_undefined(_data)
        _n = new __iteminst(_data)
    else 
    	_n = new __iteminst()
        
    party_getdata(_party_name, "spells")[_spell_index] = _n
}

/// @desc for weapons and armors
function item_apply(item_struct, party_name) {
    if !is_undefined(item_struct) {
        var structnames = struct_get_names(item_struct.stats)
        for (var i = 0; i < array_length(structnames); ++i) {
            party_adddata(party_name, structnames[i], struct_get(item_struct.stats, structnames[i]))
        }
    }
}
/// @desc for weapons and armors
function item_deapply(item_struct, party_name) {
    if !is_undefined(item_struct) {
        var structnames = struct_get_names(item_struct.stats)
        for (var i = 0; i < array_length(structnames); ++i) {
            party_subtractdata(party_name, structnames[i], struct_get(item_struct.stats, structnames[i]))
        }
    }
}

/**
 * localizes the item using the struct in the localization file
 * @param {string} _loc the loc_id of the item struct
 */
function item_localize(_loc) {
    var __data = loc(_loc)
    var __names = struct_get_names(__data)
    
    for (var i = 0; i < array_length(__names); i ++) {
        var __value = struct_get(__data, __names[i])
        if is_struct(__value) && is_struct(struct_get(__data, __names[i])) { // loop through the struct and avoid deleting already existing hashes
            for (var j = 0; j < struct_names_count(__value); j ++) {
                var n = struct_get_names(__value)[j]
                struct_set(struct_get(self, __names[i]), n, struct_get(__value, n))
            }
        }
        else
            struct_set(self, __names[i], __value)
    }
}