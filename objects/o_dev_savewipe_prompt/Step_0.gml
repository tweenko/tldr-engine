global.console = true
timer ++

if !end_cutscene
    alpha = lerp(alpha, 1, .2)

if timer < 20 || end_cutscene
    exit

if InputPressed(INPUT_VERB.LEFT)
    selection = 0
else if InputPressed(INPUT_VERB.RIGHT)
    selection = 1

if selection == 0
    soulx_target = 320 - 50 - 30
if selection == 1
    soulx_target = 320 + 60 - 30

soulx = lerp(soulx, soulx_target, .4)

if InputPressed(INPUT_VERB.SELECT) && selection != -1 {
    if selection == 1 {
        audio_play(snd_ui_cancel)
        instance_destroy()
    }
    else {
        o_world.save_settings = false
        save_wipe()
        
        cutscene_create()
        cutscene_set_variable(id, "end_cutscene", true)
        cutscene_animate(1, 0, 20, anime_curve.linear, id, "alpha")
        cutscene_sleep(10)
        
        cutscene_func(function() {
            o_dev_savewipe_prompt.inst_dialogue = text_typer_create(loc("txt_debug_save_erase"), 130, 160, DEPTH_UI.CONSOLE - 100, "{auto_breaks(false)}{preset(`god_text`)}{can_skip(false)}", "{p}{e}", {
                gui: true,
                center_x: true,
                can_superskip: false,
                ignore_console: true,
            })
        })
        cutscene_wait_until(function() {
            return !instance_exists(o_dev_savewipe_prompt.inst_dialogue)
        })
        
        cutscene_func(function() {
            game_end()
        })
        cutscene_play()
    }
}