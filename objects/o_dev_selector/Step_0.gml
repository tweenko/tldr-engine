global.console = true

// menu movement
if InputRepeat(INPUT_VERB.UP) {
	selection --
    
	if selection < 0 {
        category --
       if category < 0
           category = array_length(display_list) - 1
        selection = array_length(display_list[category].items) - 1
    }
}
if InputRepeat(INPUT_VERB.DOWN) {
    selection ++
    
	if selection >= array_length(display_list[category].items) {
        selection = 0
        category ++
    }
    if category >= array_length(display_list)
        category = 0
}

scroll = lerp(scroll, max(0, soul_y - 480/2 - 40), .3)

if InputPressed(INPUT_VERB.SELECT) {
	if !array_contains(item_blocked, display_list[category].items[selection]) 
        select(display_list[category].items[selection])
	else 
		audio_play(snd_ui_cant_select)
}
if InputPressed(INPUT_VERB.CANCEL) {
	instance_destroy()
}