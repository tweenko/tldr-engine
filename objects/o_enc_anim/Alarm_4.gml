/// @desc find the enemy actors (or create them)

for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
    var obj = noone
	var a = actor_find(encounter_data.enemies[i].obj, x, y,, {is_selected_for_battle: false})
	var create = true // whether to create the actors
	
	if a != noone {
		if !a.is_in_battle {
			obj = a
			create = false
		}
	}
	
    if instance_exists(obj) {
        obj.is_selected_for_battle = true
        
        with obj
            path_end()
        obj.image_xscale = (obj.sprite_facing_dir == DIR.RIGHT ? -1 : 1)
    }
	enemy_objects[i] = obj
}