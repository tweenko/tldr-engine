target_room = -1;

__intro_seq = method(self, function(){});

__intro_init = method(self, function(_debug_call=false) {
	target_room = room_save_select;
	
	if _debug_call {
		target_room = global.last_room;
	}	
	
	event_user(0);
	__intro_seq();
})
