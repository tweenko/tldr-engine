///@desc adds 1 to the amount of recruited enemies, recruits if you've finished it all (uses the enemy struct)
///@arg {struct.enemy} _enemy the struct of the enemy you want to check for
function recruit_advance(_enemy) {
	var r = global.recruits
	
	if recruit_isrecruited(_enemy) || recruit_islost(_enemy) // already full
		return -1
    if recruit_get_struct(_enemy) == undefined // if not added to the recruit array yet, just add it
        array_push(r, _enemy.recruit)
    
    var __struct = recruit_get_struct(_enemy)
    __struct.progress = clamp(__struct.progress + 1, 0, __struct.need)
}

///@desc adds recruit to the LOST recruits so you cannot recruit them again
function recruit_lose(_enemy) {
    var r = global.recruits
    
    if !recruit_islost(_enemy) {
        array_push(global.recruits_lost, instanceof(_enemy.recruit))
        
        if recruit_isrecruited(_enemy)
            array_delete(r, recruit_get_index(_enemy), 1)
    }
}

///@desc returns the target amount of enemies to recruit
///@arg {struct.enemy} _enemy the struct of the enemy you want to check for (uses the enemy struct)
/// /// @return {real}
function recruit_getneed(_enemy) {
	return _enemy.recruit.need
}

/// @desc returns whether or not the recruit struct is for the same enemy or not
function recruit_is_same(_struct, _struct_og) {
    return is_instanceof(_struct, asset_get_index(instanceof(_struct_og)))
}

///@desc returns the struct of the recruit. returns undefined if none is found (uses the enemy struct)
///@arg {struct.enemy} _enemy the struct of the enemy you want to check for
/// @return {struct,undefined}
function recruit_get_struct(_enemy) {
	var r = global.recruits
	
    for (var i = 0; i < array_length(r); i ++) {
        var __c = r[i]
        if recruit_is_same(__c, _enemy.recruit)
            return __c
    }
    
    return undefined
}
///@desc returns the struct of the recruit. returns undefined if none is found (uses the enemy struct)
///@arg {struct.enemy} _enemy the struct of the enemy you want to check for
/// @return {real,undefined}
function recruit_get_index(_enemy) {
	var r = global.recruits
	
    for (var i = 0; i < array_length(r); i ++) {
        var __c = r[i]
        if recruit_is_same(__c, _enemy.recruit)
            return i
    }
    
    return undefined
}

///@desc returns the progress of the recruit (uses the enemy struct)
///@arg {struct.enemy} _enemy the struct of the enemy you want to check for
function recruit_get_progress(_enemy) {
	var r = global.recruits
	
    for (var i = 0; i < array_length(r); i ++) {
        var __c = r[i]
        if recruit_is_same(__c, _enemy.recruit)
            return __c.progress
    }
    
    return 0
}

///@desc returns whether the enemy is recruited already (uses the enemy struct)
///@arg {struct.enemy} _enemy the struct of the enemy you want to check for
function recruit_isrecruited(_enemy) {
	if recruit_get_progress(_enemy) >= _enemy.recruit.need
        return true
    
    return false
}
///@desc returns whether the enemy is lost (uses the enemy struct)
function recruit_islost(_enemy) {
    return array_contains(global.recruits_lost, instanceof(_enemy.recruit))
}

/**
 * localizes the recruit struct using the struct in the localization file, a hyperlink to item_localize
 * @param {string} _loc the loc_id of the item struct
 */
function recruit_localize(_loc) {
    item_localize(_loc)
}