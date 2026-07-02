/// @description player input


if pf_enabled>0 { // Platforming mode
	player_platforming_movement_execute()
	player_standard_interaction_and_menutoggle_execute()// <-- attacking/act goes here
}
else { // Standard mode
	player_standard_movement_execute()
	player_standard_interaction_and_menutoggle_execute()
}

// make steps and call the `__step` method
if !sliding and pf_enabled{
	if !made_step and floor((image_index % image_number)*2) % 2 != 0 {
		__step(floor(image_index % image_number));
		made_step = true;
	}
	else {made_step = false}
}