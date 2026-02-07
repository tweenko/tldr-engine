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

if keyboard_check_pressed(vk_anykey) {
    for (var i = 0; i < array_length(display_list); i ++) {
        if (i < 9 && keyboard_key == ord(string(i + 1))) || keyboard_key == display_list[i].keybind {
            selection = 0
            category = i
        }
    }
}

if keyboard_check_pressed(vk_enter) {
	if !array_contains(item_blocked, display_list[category].items[selection]) 
        select(display_list[category].items[selection])
	else 
		audio_play(snd_ui_cant_select)
}
if keyboard_check_pressed(vk_escape) {
	instance_destroy()
}