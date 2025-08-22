/// @description end
xoff = 0
yoff = 0

for (var i = 0; i < array_length(mychars); ++i) {
	instance_destroy(mychars[i])
}

mychars = []

instance_destroy()

// destroy the caller if ordered to
if instance_exists(caller) {
	if variable_instance_exists(caller, "die_delay") 
		&& caller.die_delay == 0 
		|| !variable_instance_exists(caller, "die_delay") 
	{
		if destroy_caller 
			instance_clean(caller)
	}
	else 
		call_later(caller.die_delay, time_source_units_frames, function() {
			instance_destroy(caller)
		})
}
instance_clean(face_inst)

dont_update = true
if instance_exists(npc_link){
	if variable_instance_exists(npc_link, "s_talking"){
		npc_link.s_talking = false
	}
}