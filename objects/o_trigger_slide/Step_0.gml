event_inherited()
if triggered {
	with target 
		y += global.slide_speed
	if timer % 4 == 0 && target.y < y + sprite_height && target.y > y + 20
		instance_create(o_eff_slidedust, target.x, target.y - 30, target.depth)
	
	timer ++
}

if instance_exists(target){
	for (var i = 1; i < party_length(true); ++i) {
		var o = party_get_inst(global.party_names[i])
		
		if o.sliding && !o.prevsliding {
			o.sprite_index = o.s_slide
			o.s_override = true
			o.slideinst = id
			o.follow = false
		}
		else if !o.sliding && o.prevsliding {
			o.s_override = false
			o.dir = DIR.DOWN
			o.follow = follow_save
			
			with o 
				event_user(1)
			party_member_interpolate(o.name)
		}
	}
}