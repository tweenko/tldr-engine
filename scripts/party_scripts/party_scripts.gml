/// @desc returns the current number of party members
/// @arg {bool} full when false, limits the number to `global.party_limit`
function party_length(full = false) {
    if full
        return array_length(global.party_names)
    return min(array_length(global.party_names), (global.party_limit ?? infinity))
}

///@desc returns the party leader at the moment
function get_leader(){
	return party_get_inst(global.party_names[0])
}

/// @desc adds a party member to the end of the party ensemble
/// @arg {string} name the name of the party member to add
function party_member_add(name) {
    array_push(global.party_names, name)
    
    if !instance_exists(get_leader())
        exit
    
    var lx = get_leader().x
    var ly = get_leader().y
    party_member_create(name)
    party_reposition(lx, ly)
}

/// @desc kicks out a party member (and deletes their object, if applicable)
/// @arg {string} name the name of the party member to kick
function party_member_kick(name) {
    array_delete(global.party_names, party_get_index(name), 1)
    if !instance_exists(get_leader())
        exit
    
    var lx = get_leader().x
    var ly = get_leader().y
    instance_destroy(party_get_inst(name))
    party_reposition(lx, ly)
    
    with get_leader() {
        is_player = true
        is_follower = false
        event_user(2)
    }
}

/// @desc creates an actor standing in for the party leader
function party_leader_create(name, xx, yy, ddepth) {
	var pl = actor_create(party_get_obj(name), xx, yy, ddepth)
	o_camera.target = pl.id
	
	pl.is_player = true
    pl.is_party = true
	with pl {
		event_user(2)
        __initialize()
    }
	party_setdata(name, "actor_id", pl)
	
	return pl
}
/// @desc warps the party leader to a marker
/// @arg {string,any} target_marker_type
/// @arg {string,any} target_marker_id
/// @arg {enum.DIR} warp_dir the direction the leader and party will be facing after being warped
function party_leader_warp(target_marker_type, target_marker_id, warp_dir = DIR.DOWN) {
    if !instance_exists(get_leader()) 
        return false
    
    var marker = marker_get(target_marker_type, target_marker_id)
    
    if instance_exists(marker) {
        get_leader().x = marker.x
        get_leader().y = marker.y
        
        get_leader().dir = warp_dir
    }
    for (var i = 0; i < party_length(true); ++i) {
        with party_get_inst(global.party_names[i]) {
            x = get_leader().x
            y = get_leader().y
            dir = get_leader().dir
            
            event_user(1)
        }
    }
}

///@desc creates an actor standing in for the party member
function party_member_create(name, recordnow = true, xx = get_leader().x, yy = get_leader().y) {
	var inst = actor_create(party_get_obj(name), xx, yy, get_leader().depth)
	inst.is_follower = true
    inst.is_party = true
	inst.pos = get_leader().spacing * party_get_index(name)
	
	with inst {
		if recordnow 
			event_user(1)
		event_user(2)
		__initialize()
	}
	party_setdata(name, "actor_id", inst)
	
	return inst
}

///@desc interpolates the party position to attach them back to the "caterpillar"
function party_member_interpolate(name){
	if !instance_exists(party_get_inst(name)) 
		exit
    
	with party_get_inst(name) {
		var ddir = actor_angletodir(point_direction(x, y, get_leader().x, get_leader().y))
		record[0][0] = get_leader().x
		record[1][0] = get_leader().y
		record[2][0] = get_leader().dir
		
		for (var i = pos; i > 0; i -= 1)
		{
			record[0][i] = lerp(get_leader().x, x, (i / pos))
			record[1][i] = lerp(get_leader().y, y, (i / pos))
			record[2][i] = ddir
			record[3][i] = false
		}
	}
}

///@desc recalculates the position of the party members
function party_reposition(lx = get_leader().x, ly = get_leader().y){
	var ddepth = get_leader().depth
	
	if instance_exists(party_get_inst(global.party_names[0])) {
		var pl = party_get_inst(global.party_names[0])
		
		pl.x = lx
		pl.y = ly
		
		o_camera.target = pl.id
		
		pl.is_player = true
		with pl 
			event_user(2)
	}
	for (var i = 1; i < party_length(true); ++i) {
		if instance_exists(party_get_inst(global.party_names[i])) {
			var inst = party_get_inst(global.party_names[i])
			inst.is_follower = true
			inst.pos = get_leader().spacing * party_get_index(global.party_names[i])
			
			with inst { // set position, initialize the followers
				if array_length(record) == 0 
					event_user(1)
				
				x = record[0][pos]
				y = record[1][pos]
				dir = record[2][pos]
				
				event_user(2)
				init = true
			}
		}
	}
}

/// @desc returns whether the party member is a part of the current party
/// @arg {string} _name the name of the party member you'd like to check for
/// @arg {bool} _full_party whether to check for the full party (above the party limit)
function party_contains(_name, _full_party = false) {
    for (var i = 0; i < party_length(_full_party); i ++) {
        if global.party_names[i] == _name 
            return true
    }
    
	return false
}

/// @desc sets the state of a party member (sprite state)
/// @arg {string} _name
/// @arg {string} _state 
function party_set_state(_name, _state) {
    party_setdata(_name, "s_state", _state)
    
    with party_get_inst(_name)
        event_user(2)
}

/// @desc  returns the party sprite with a certain naming scheme.
/// the examples below are based on the following example sprite:
/// `spr_ex_berdly_down_sad`
/// @param {string} name         the name of the party member
/// @param {string} identifier   the sprite identifier (e.g. `down`)
/// @param {string} [prefix]     the sprite prefix (e.g. `ex`)
/// @param {string} [state]      the actor state. always at the very end of the sprite name and not a part of the naming scheme (e.g. `sad`)
/// @param {string} [scheme]             the sprite name scheme. by default it's `"spr_{0}_{1}_{2}"`, where {0} is the prefix, {1} is the name and {2} is the identifier
/// @param {array} [scheme_addelements]  an array containing optional elements. in the default scheme there are only three slots for change, but here you can add more, if your scheme requires more
/// @param {asset.gmsprite} [fallback]   the default sprite to use in case of failure
/// @returns {asset.GMSprite}
function party_get_sprite_from_scheme(name, identifier, prefix = "", state = "", scheme = "spr_{0}_{1}_{2}", optional_arguments = [], fallback = spr_default) {
    var __target_sprite = string_ext(scheme, array_concat([prefix, name, identifier], optional_arguments))
    while string_contains("__", __target_sprite) {
        __target_sprite = string_replace_all(__target_sprite, "__", "_")
    }
    
    var __a = asset_get_index_state(__target_sprite, state)
    if sprite_exists(__a) 
        return __a
    else 
        return fallback
}

/// @desc  returns the party sprite with a certain naming scheme.
/// the examples below are based on the following example sprite:
/// `spr_ex_berdly_down_sad`
/// @param {string} name         the name of the party member
/// @param {string} [prefix]     the sprite prefix (e.g. `ex`)
/// @param {string} [state]      the actor state. always at the very end of the sprite name and not a part of the naming scheme (e.g. `sad`)
/// @param {string} [scheme]             the sprite name scheme. by default it's `"spr_{0}_{1}_{2}"`, where {0} is the prefix, {1} is the name and {2} is the identifier
/// @param {array} [scheme_addelements]  an array containing optional elements. in the default scheme there are only three slots for change, but here you can add more, if your scheme requires more
/// @param {asset.gmsprite} [fallback]   the default sprite to use in case of failure
/// @returns {array<Asset.GMSprite>}
function party_get_cardinal(name, prefix = "", state = "", scheme = "spr_{0}_{1}_{2}", optional_arguments = [], fallback = spr_default) {
    var cardinal = []
    for (var i = 0; i < 360; i += 90) {
        cardinal[i] = party_get_sprite_from_scheme(name, dir_to_string(i), prefix, state, scheme, optional_arguments, fallback)
    }
    return cardinal
}

/// @desc returns the array with the sprites for the actor's cardinal directions
/// @arg {string} party_name the init name of the party member who's sprite we're looking for
/// @arg {enum.WORLD} world the world type to get the sprite of
function party_m_get_cardinal(party_name, world = global.world) {
    var __struct = party_get_struct(party_name)
    var __cardinal = []
    with __struct {
        __cardinal = party_get_cardinal(s_name, s_prefix, s_state + (world ==  WORLD_TYPE.LIGHT ? "_light" : ""), s_scheme, s_scheme_addelements, s_fallback)
    }
    return __cardinal
}

/// @desc returns the sprite of a member with a certain identifier
/// @arg {string} party_name the init name of the party member who's sprite we're looking for
/// @arg {string} identifier the unique identifier of the sprite you're looking for
/// @arg {enum.WORLD} world the world type to get the sprite of
/// @returns {Asset.GMSprite}
function party_m_get_sprite(party_name, identifier, world = global.world) {
    var __struct = party_get_struct(party_name)
    var __sprite = -1
    with __struct {
        __sprite = party_get_sprite_from_scheme(s_name, identifier, s_prefix, s_state + (world == WORLD_TYPE.LIGHT ? "_light" : ""), s_scheme, s_scheme_addelements, s_fallback)
    }
    
    return __sprite
}