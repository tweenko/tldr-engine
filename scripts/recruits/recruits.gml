///@desc adds 1 to the amount of recruited enemies, recruits if you've finished it all
///@arg {struct.enemy_base} enemy the struct of the enemy you want to check for
function recruit_advance(enemy) {
	var r = save_get("recruits")
	var rp = save_get("RECRUIT_PROGRESS")
	
	if recruit_isrecruited(enemy) // already full
		return -1
	if struct_exists(rp, enemy.recruit.name) { // advance
		struct_set(rp, enemy.recruit.name, struct_get(rp, enemy.recruit.name) + 1)
		if struct_get(rp, enemy.recruit.name) > enemy.recruit.need {
			struct_remove(rp, enemy.recruit.name)
			struct_set(r, enemy.recruit.name, enemy.recruit)
		}
	}
	else // create
		struct_set(rp, enemy.recruit.name, 1)
}

///@desc returns the amount of recruited enemies.
///@arg {struct.enemy_base} enemy the struct of the enemy you want to check for
function recruit_get(enemy) {
	var r = save_get("recruits")
	var rp = save_get("RECRUIT_PROGRESS")
	
	if struct_exists(r, enemy.recruit.name) // already full
		return undefined // already full
	if !struct_exists(rp, enemy.recruit.name)
		return 0
	
	return struct_get(rp, enemy.recruit.name)
}


///@desc returns the target amount of enemies to recruit
///@arg {struct.enemy_base} enemy the struct of the enemy you want to check for
function recruit_getneed(enemy) {
	return enemy.recruit.need
}

///@desc returns whether the enemy is recruited already
///@arg {struct.enemy_base} enemy the struct of the enemy you want to check for
function recruit_isrecruited(enemy) {
	var r = save_get("recruits")
	var rp = save_get("RECRUIT_PROGRESS")
	
	return struct_exists(r, enemy.recruit.name)
}