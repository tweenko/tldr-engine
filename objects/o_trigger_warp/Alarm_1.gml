if instance_exists(get_leader()) {
	var pos = marker_getpos("land", target_marker)
    
	if is_struct(pos) {
		get_leader().x = pos.x
		get_leader().y = pos.y
		get_leader().dir = savedir
	}
	for (var i = 0; i < array_length(global.party_names); ++i) {
	    with party_get_inst(global.party_names[i]) {
			x = get_leader().x
			y = get_leader().y
			dir = get_leader().dir
			
			event_user(1)
		}
	}
}
call_later(1, time_source_units_frames, function() {
	do_anime(1, 0, 10, "linear", function(v){
		if instance_exists(o_fader) 
			o_fader.image_alpha = v
	})
})
instance_destroy()