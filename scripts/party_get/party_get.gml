///@arg {String} name
///@return {Struct.party_m}
///@desc converts the party name to their struct name
function party_nametostruct(name) {
	return struct_get(global.party, string_lower(name))
}

///@arg {String} name
///@arg {String} value
///@return {Any}
///@desc returns a value from the party struct
function party_getdata(name, value) {
	return struct_get(party_nametostruct(name), value)
}

///@arg {string} name
///@desc returns the full name of a party member
function party_getname(name, full = true) {
	if struct_exists(party_nametostruct(name), "name_t") && !full 
		return loc(party_getdata(name, "name_t"))
	else 
		return loc(party_getdata(name, "name"))
}
///@arg {String} name
///@desc returns the index of a party member using their name
function party_getpos(name) {
	return array_get_index(global.party_names, name)
}

///@arg {String} name
///@desc returns the height of a party member that would be used for centering on the y axis
function party_getbattleheight(name) {
	var ret = party_getdata(name, "battle_sprites").idle
	if is_array(ret) 
		ret = ret[0]
	
	return sprite_get_height(ret)
}

///@desc returns the possible amount of party members
function party_getpossiblecount() {
	return struct_names_count(global.party)
}

///@desc returns the icon of a party member
function party_geticon(name) {
	var a = sprite_get_name(party_getdata(name, "s_icon"))
	return asset_get_index_state(a, party_getdata(name, "s_state"))
}
///@desc returns the hurt icon of a party member
function party_geticon_hurt(name) {
	var a = sprite_get_name(party_getdata(name, "s_icon"))
	return asset_get_index_state(a, "hurt" + (party_getdata(name, "s_state") == "" ? "" : "_") + party_getdata(name, "s_state"))
}

///@desc returns the overworld icon of a party member
function party_geticon_ow(name) {
	var a = sprite_get_name(party_getdata(name, "s_icon_ow"))
	return asset_get_index_state(a, party_getdata(name, "s_state"))
}

///@desc returns the id of the party member using their name
function party_get_inst(name) {
	return party_getdata(name, "actor_id")
}
///@desc returns the object variable from the party struct
function party_get_obj(name) {
	return party_getdata(name, "obj")
}

///@desc returns whether a party member is up
function party_isup(name) {
	return party_getdata(name, "hp") > 0
}