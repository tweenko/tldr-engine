function player_standard_interaction_and_menutoggle_execute(_can_interact=true, _can_menutoggle=true){
	// Interact
	if InputPressed(INPUT_VERB.SELECT)
	and _can_interact
	{
		for (var w = 2; w < 15; w ++) {
			var __xw = -lengthdir_x(w, dir + 90)
			var __yw = lengthdir_y(w, dir + 90)
			var __interactable_instances = instance_place_list_ext(x + __xw, y + __yw, array_concat([o_ow_interactable, o_actor_interactable], interactable_instances), false)
			for (var i = 0; i < array_length(__interactable_instances); i ++) {
				with __interactable_instances[i] {
					if other._checkmove() event_user(0)
				}
			}
			if array_length(__interactable_instances) > 0 break
		}
	}

	// Menu
	else if InputPressed(INPUT_VERB.SPECIAL)
	and _can_menutoggle
	and !instance_exists([o_ui_menu, o_ui_menu_lw]) 
	and !o_dodge_controller.dodge_mode
	{
		if sliding
		//or place_meeting(x, y, o_trigger_jumpattack)
		{ // Play a deny sound for certain cases.
			audio_stop_sound(snd_error)
			audio_play(snd_error,,,, 1)
		}
		else { // Otherwise, open it.
			if global.world == WORLD_TYPE.DARK instance_create(o_ui_menu)
			else if global.world == WORLD_TYPE.LIGHT instance_create(o_ui_menu_lw)
		}
	}
}