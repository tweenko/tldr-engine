global.console = true
timer ++

alpha = lerp(alpha, 1, .2)
if timer < 20
    exit

if keyboard_check_pressed(vk_left)
    selection = 0
else if keyboard_check_pressed(vk_right)
    selection = 1

if keyboard_check_pressed(vk_enter) && selection != -1 {
    if selection == 1 {
        if fatal
            game_end()
        else {
            audio_play(snd_ui_cancel)
            instance_destroy()
        }
    }
    else {
        o_world.save_settings = false
        save_wipe()
        game_end()
    }
}