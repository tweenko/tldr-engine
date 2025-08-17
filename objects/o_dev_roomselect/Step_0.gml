global.console = true

// menu movement
if InputRepeat(INPUT_VERB.UP) {
	if selection > 0 {
		selection --
	}
}
if InputRepeat(INPUT_VERB.DOWN) {
	if selection < room_last {
		selection++
	}
}

if InputPressed(INPUT_VERB.SELECT) {
	if !array_contains(inaccessible, selection) {
        music_stop_all()
		audio_play(snd_ui_select)
		room_goto(asset_get_index(room_get_name(selected_room)))
	}
	else 
		audio_play(snd_ui_cant_select)
}
if InputPressed(INPUT_VERB.CANCEL) {
	instance_destroy()
}