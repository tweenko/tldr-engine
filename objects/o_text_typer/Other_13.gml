/// @description end

xoff = 0
yoff = 0

for (var i = 0; i < array_length(mychars); ++i) {
	instance_destroy(mychars[i])
}
for (var i = 0; i < array_length(mini_faces); ++i) {
	instance_destroy(mini_faces[i])
}

mychars = []
mini_faces = []

instance_destroy()

// destroy the caller if ordered to
if instance_exists(caller) {
	if variable_instance_exists(caller, "die_delay") 
		&& caller.die_delay == 0 
		|| !variable_instance_exists(caller, "die_delay") 
	{
		if destroy_caller 
			instance_destroy(caller)
	}
	else 
		call_later(caller.die_delay, time_source_units_frames, function() {
			instance_destroy(caller)
		})
}

instance_destroy(face_inst)
instance_destroy(o_ui_money_display)

__update_talking(false)

dont_update = true