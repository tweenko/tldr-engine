/// @desc find the enemy actors (or create them)

for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
    var obj = noone
	var a = actor_find(encounter_data.enemies[i].obj, x, y)
	var create = true // whether to create the actors
	
	if a != noone {
		if !a.is_in_battle {
			obj = a
			create = false
		}
	}
	
	enemy_objects[i] = obj
}