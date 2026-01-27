party_leader_create(global.party_names[0], x, y, depth)
for (var i = 1; i < array_length(global.party_names); ++i) {
	party_member_create(global.party_names[i], recordnow)
}