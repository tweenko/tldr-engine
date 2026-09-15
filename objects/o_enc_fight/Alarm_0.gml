var mmin = infinity

enemy_hp = array_create_ext(array_length(caller.encounter_data.enemies), function(index) {
    if !enc_enemy_is_fighting(index)
        return 0
    return caller.encounter_data.enemies[index].hp
})
for (var i = 0; i < array_length(fighting); ++i) {
	var rand = irandom(array_length(fighting) - 1)
	array_push(pattern, rand)
	if rand < mmin
		mmin = rand
}

// make it so we don't have to wait randomly by trimming the pattern to the longest one
for (var i = 0; i < array_length(pattern); ++i) {
	pattern[i] -= mmin
}

for (var i = 0; i < array_length(fighting); ++i) {
	var spacing = 14*8
    var index = party_get_index(fighting[i])
	var yy = ui_fightbar_height * index;
	array_push(sticks, instance_create(o_enc_fightstick, ui_crit_x - 2 + 30*7 + pattern[i]*spacing, ui_fightarea_y + yy + ui_fightbar_height/2, depth - 10, {
		order: pattern[i],
		caller: id,
		ecaller: caller,
		index: index,
		ii: i,
		target: fighterselection[i],
	}))
}