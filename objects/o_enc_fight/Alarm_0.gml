var mmin = infinity

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
	var yy = 38 * array_get_index(global.party_names, fighting[i])
	array_push(sticks, instance_create(o_enc_fightstick, 80 + 30*7 + pattern[i]*spacing, 365 + yy + 19, depth - 10, {
		order: pattern[i],
		caller: id,
		ecaller: caller,
		index: array_get_index(global.party_names, fighting[i]),
		ii: i,
		target: fighterselection[i],
	}))
}