global.console = true

// menu movement
if InputRepeat(INPUT_VERB.UP) {
	if selection > 0
		selection --
}
if InputRepeat(INPUT_VERB.DOWN) {
	if selection < array_length(room_list)
		selection ++
}

if InputPressed(INPUT_VERB.SELECT) {
	if !array_contains(inaccessible, room_list[selection]) {
        music_stop_all()
		audio_play(snd_ui_select)
		room_goto(room_list[selection])
	}
	else 
		audio_play(snd_ui_cant_select)
}
if InputPressed(INPUT_VERB.CANCEL) {
	instance_destroy()
}