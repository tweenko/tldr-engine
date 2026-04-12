frames ++

if instance_exists(o_dev_savewipe_prompt)
    exit;

if keyboard_check_pressed(vk_f2)
	game_restart()
if keyboard_check_pressed(vk_f4) {
	window_set_fullscreen(!window_get_fullscreen())
    if !window_get_fullscreen()
        window_center()
}

if frames % 30 == 0
	global.time ++