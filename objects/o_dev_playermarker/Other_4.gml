party_leader_create(global.party_names[0], x, y, depth)
for (var i = 1; i < party_length(true); i ++) {
	party_member_create(global.party_names[i], recordnow)
}