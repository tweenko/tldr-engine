event_inherited()

if !instance_exists(inst) && started {
	started = false
	
	for (var i = 0; i < array_length(global.party_names); ++i) {
		party_setdata(global.party_names[i], "hp", party_getdata(global.party_names[i], "max_hp"))
	}
	
	instance_create(o_ui_save)
}

if global.world = WORLD_TYPE.LIGHT && instance_exists(get_leader()) {
    image_alpha = .5 + max(0, 1 - distance_to_object(get_leader())/12)/2
}