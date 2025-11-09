room_goto(target_room)
if audio_exists(exit_sound)
    audio_play(exit_sound)

call_later(2, time_source_units_frames, function() {
    if instance_exists(get_leader()) {
    	var marker = marker_get("land", target_marker)
        
    	if instance_exists(marker) {
    		get_leader().x = marker.x
    		get_leader().y = marker.y
            
    		get_leader().dir = exit_direction ?? savedir
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
        fader_fade(1, 0, 10)
    })
})