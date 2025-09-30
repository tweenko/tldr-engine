for (var i = 0; i < array_length(o_enc.encounter_data.enemies); ++i) {
	var enemy = o_enc.encounter_data.enemies[i]
	if enc_enemy_isfighting(i) 
		do_animate(0, .5, 10, "linear", enemy.actor_id, "darken")
}