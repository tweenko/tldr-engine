///@desc adds 1 to the amount of recruited enemies, recruits if you've finished it all
///@arg {struct.enemy} _enemy the struct of the enemy you want to check for
function recruit_advance(_enemy) {
	var r = save_get("recruits")
	
	if recruit_isrecruited(_enemy) || recruit_islost(_enemy) // already full
		return -1
    if recruit_get_struct(_enemy) != undefined // if not added to the recruit array yet, just add it
        array_push(r, _enemy.recruit)
    
    recruit_get_struct(_enemy).progress = clamp(recruit_get_struct(_enemy).progress + 1, 0, recruit_get_struct(_enemy).need)
}
function recruit_lose(_enemy) {
    var r = save_get("recruits_lost")
    
    if !recruit_islost(_enemy) {
        array_push(r, _enemy.recruit.name)
        array_delete(r, recruit_get_index(_enemy), 1)
    }
}

///@desc returns the target amount of enemies to recruit
///@arg {struct.enemy} _enemy the struct of the enemy you want to check for
/// /// @return {real}
function recruit_getneed(_enemy) {
	return _enemy.recruit.need
}

///@desc returns the struct of the recruit. returns undefined if none is found
///@arg {struct.enemy} _enemy the struct of the enemy you want to check for
/// @return {struct,undefined}
function recruit_get_struct(_enemy) {
	var r = save_get("recruits")
	
    for (var i = 0; i < array_length(r); i ++) {
        var __c = r[i]
        if __c.name == _enemy.recruit.name
            return __c
    }
    
    return undefined
}
///@desc returns the struct of the recruit. returns undefined if none is found
///@arg {struct.enemy} _enemy the struct of the enemy you want to check for
/// @return {real,undefined}
function recruit_get_index(_enemy) {
	var r = save_get("recruits")
	
    for (var i = 0; i < array_length(r); i ++) {
        var __c = r[i]
        if __c.name == _enemy.recruit.name
            return i
    }
    
    return undefined
}

///@desc returns the progress of the recruit
///@arg {struct.enemy} _enemy the struct of the enemy you want to check for
function recruit_get_progress(_enemy) {
	var r = save_get("recruits")
	
    for (var i = 0; i < array_length(r); i ++) {
        var __c = r[i]
        if __c.name == _enemy.recruit.name {
            return __c.progress
        }
    }
    
    return 0
}
///@desc returns whether the enemy is recruited already
///@arg {struct.enemy} _enemy the struct of the enemy you want to check for
function recruit_isrecruited(_enemy) {
	if recruit_get_progress(_enemy) >= _enemy.recruit.need
        return true
    return false
}
///@desc returns whether the enemy is lost
function recruit_islost(_enemy) {
    return array_contains(save_get("recruits_lost"), _enemy.recruit.name)
}