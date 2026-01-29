frames ++

if incompatible_end_cutscene
    exit

if keyboard_check_pressed(vk_f2)
	game_restart()
if keyboard_check_pressed(vk_f4) {
	window_set_fullscreen(!window_get_fullscreen())
    if !window_get_fullscreen()
        window_center()
}

if frames % 30 == 0
	global.time ++

if incompatible_save_warning && incompatible_save_sleep == 0 {
    if InputPressed(INPUT_VERB.LEFT)
        incompatible_selection = 0
    else if InputPressed(INPUT_VERB.RIGHT)
        incompatible_selection = 1
    
    if incompatible_selection == 0
        incompatible_soulx_target = 320 - 50 - 30
    if incompatible_selection == 1
        incompatible_soulx_target = 320 + 60 - 30
    
    incompatible_soulx = lerp(incompatible_soulx, incompatible_soulx_target, .4)
    
    if InputPressed(INPUT_VERB.SELECT) && incompatible_selection != -1 {
        if incompatible_selection == 1 {
            audio_play(snd_ui_cancel)
            incompatible_save_warning = false
            
            game_end()
        }
        else {
            o_world.save_settings = false
            save_wipe()
            
            cutscene_create()
            cutscene_set_variable(id, "incompatible_end_cutscene", true)
            cutscene_animate(1, 0, 20, anime_curve.linear, id, "incompatible_alpha")
            cutscene_sleep(10)
            
            cutscene_func(function() {
                o_world.inst_dialogue = text_typer_create(loc("txt_debug_save_erase"), 130, 160, DEPTH_UI.CONSOLE - 100, "{auto_breaks(false)}{preset(`god_text`)}{can_skip(false)}", "{p}{e}", {
                    gui: true,
                    center_x: true,
                    can_superskip: false,
                    ignore_console: true,
                })
            })
            cutscene_wait_until(function() {
                return !instance_exists(o_world.inst_dialogue)
            })
            
            cutscene_func(function() {
                game_end()
            })
            cutscene_play()
        }
    }
}

if incompatible_save_sleep > 0
    incompatible_save_sleep --