get_leader().moveable_anim = true
transitioning = false

for (var i = 0; i < party_length(true); ++i) {
	var o = party_get_inst(global.party_names[i])
	if !instance_exists(o) 
        continue
    
	o.follow = true
	o.image_alpha = 1
	
	party_member_interpolate(global.party_names[i])
}