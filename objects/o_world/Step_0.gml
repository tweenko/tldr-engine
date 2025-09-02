frames ++

if keyboard_check_pressed(vk_f2)
	game_restart()
if keyboard_check_pressed(vk_f4)
	window_set_fullscreen(!window_get_fullscreen())

if frames % 30 == 0
	global.time ++

if incompatible_save_warning && incompatible_save_sleep == 0 {
    if InputPressed(INPUT_VERB.SELECT) {
        audio_play(snd_ui_cancel)
        incompatible_save_warning = false
        
        room_goto_next()
    }
}

if incompatible_save_sleep > 0
    incompatible_save_sleep --