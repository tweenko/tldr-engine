if get_leader()._checkmove() {
	if !myswitch.active {
		y += spd
		if walk
			if legsgrow > 0 
                legsgrow -= .25
	}
    else {
		if walk {
			if legsgrow < 1 
                legsgrow += .25
			y += spd/4
		}
	}
}

if y > room_height + 20 
    instance_destroy()

if transitioning {}
else {
	if collision_point(get_leader().x, get_leader().y, id, 0, 0) && get_leader()._checkmove() && (!myswitch.active || walk){
		get_leader().moveable_anim = false
		audio_play(snd_cardrive)
	
		var tgt_marker = noone
		with(o_dev_marker){
			if toggled {
                tgt_marker = id; 
                break 
            }
		}
		
		transitioning = true
		alarm[0] = 30
		
		for (var i = 0; i < array_length(global.party_names); ++i) {
			var o = party_get_inst(global.party_names[i])
			
			if !instance_exists(o) 
                continue
			o.image_alpha = .5
			o.follow = false
			animate(o.x, tgt_marker.x, 30, "linear", o, "x")
			animate(o.y, tgt_marker.y, 30, "linear", o, "y")
		}
	}
	
    if myswitch.active && !walk
		collide=true
    else 
        collide=false
}