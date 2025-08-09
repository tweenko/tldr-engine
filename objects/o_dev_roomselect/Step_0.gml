global.console = true

// menu movement
if input_check_pressed_repeat("up") {
	if selection > 0 {
		selection --
	}
}
if input_check_pressed_repeat("down") {
	if selection < room_last {
		selection++
	}
}

if input_check_pressed("confirm") {
	if !array_contains(inaccessible, selection) {
        music_stop_all()
		audio_play(snd_ui_select)
		room_goto(asset_get_index(room_get_name(selected_room)))
	}
	else 
		audio_play(snd_ui_cant_select)
}
if input_check_pressed("cancel") {
	instance_destroy()
}