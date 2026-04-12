global.console = true
timer ++

alpha = lerp(alpha, 1, .2)
if timer < 20
    exit

if InputPressed(INPUT_VERB.LEFT)
    selection = 0
else if InputPressed(INPUT_VERB.RIGHT)
    selection = 1

if InputPressed(INPUT_VERB.SELECT) && selection != -1 {
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