event_inherited()

var rm = room_first
var index = 0
while room_exists(rm) {
    if rm == room_init
        array_push(item_blocked, index)
    
    array_push(item_list, rm)
    
    rm = room_next(rm)
    index ++
}

select = function(_item, _item_index) {
    instance_destroy()
    music_stop_all()
    audio_play(snd_ui_select)
    
    room_goto(_item)
}
item_name = function(_item, _item_index) {
    return room_get_name(_item)
}

show_debug_message(item_blocked)