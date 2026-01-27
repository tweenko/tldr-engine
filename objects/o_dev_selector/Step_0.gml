global.console = true

// menu movement
if InputRepeat(INPUT_VERB.UP) {
	if selection > 0
		selection --
}
if InputRepeat(INPUT_VERB.DOWN) {
	if selection < array_length(item_list)-1
		selection ++
}

var current_y = 10 * (1 + (selection * 2)) + 5 - scroll
scroll = lerp(scroll, max(0, 10 * (1 + (selection * 2)) + 5 - 480/2), .3)

if InputPressed(INPUT_VERB.SELECT) {
	if !array_contains(item_blocked, selection)
        select(item_list[selection], selection)
	else 
		audio_play(snd_ui_cant_select)
}
if InputPressed(INPUT_VERB.CANCEL) {
	instance_destroy()
}