if image_index == 1
	exit

if is_struct(item_inside) && is_instanceof(item_inside, item) {
    image_index = 1
    audio_play(snd_locker)
    
    screen_shake(5)
    
    var txt = string(loc("item_chest_get"), item_get_name(item_inside)) + "{p}{c}"
    txt += item_add(item_inside)
    dialogue_start(txt)
}
else {
    empty_callback()
}

state_add("chests_open", id)