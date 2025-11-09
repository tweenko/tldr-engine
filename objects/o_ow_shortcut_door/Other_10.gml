cutscene_create()
cutscene_player_canmove(false)

var __choice_string = ""
var __same_room = array_length(room_name_list)
for (var i = 0; i < array_length(room_name_list); i ++) {
    __choice_string += $"`{loc(room_name_list[i])}`"
    
    if i < array_length(room_name_list)-1
        __choice_string += ", "
}
__choice_string += $", `{loc(current_room_name)}`"

cutscene_dialogue([
    loc("txt_shortcut_door"),
    "{choice(" + __choice_string + ")}",
], "{e}")

cutscene_func(function(__same_room, room_list, caller) {
    if global.temp_choice != __same_room {
        caller.image_index = 1
        
        cutscene_create()
        cutscene_player_canmove(false)
        
        cutscene_audio_play(snd_dooropen)
        cutscene_dialogue(loc("txt_shortcut_door_open"))
        cutscene_sleep(15)
        
        cutscene_func(fader_fade, [0, 1, 0])
        cutscene_func(music_stop_all)
        cutscene_audio_play(snd_doorclose)
        cutscene_sleep(30)
        
        cutscene_func(room_goto, [room_list[global.temp_choice]])
        cutscene_func(fader_fade, [1, 0, 10])
        cutscene_audio_play(snd_dooropen)
    
        cutscene_player_canmove(true)
        cutscene_play()
    }
    else {
        cutscene_create()
        cutscene_player_canmove(false)
        
        cutscene_dialogue(loc("txt_shortcut_door_already"))
        
        cutscene_player_canmove(true)
        cutscene_play()
    }
}, [__same_room, room_list, id])

cutscene_play()