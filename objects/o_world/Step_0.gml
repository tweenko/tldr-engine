frames ++

if incompatible_end_cutscene
    exit

if keyboard_check_pressed(vk_f2)
	game_restart()
if keyboard_check_pressed(vk_f4)
	window_set_fullscreen(!window_get_fullscreen())

// always set the music emitter volume
audio_emitter_gain(o_world.emitter_music, volume_get(1))

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
            save_wipe()
            
            cutscene_create()
            cutscene_set_variable(id, "incompatible_end_cutscene", true)
            cutscene_animate(1, 0, 20, "linear", id, "incompatible_alpha")
            cutscene_sleep(10)
            cutscene_func(function() {
                inst_dialogue = instance_create(o_text_typer, 130, 160, depth, {
        			text: "{auto_breaks(false)}{preset(god_text)}{can_skip(false)}" + loc("txt_debug_save_erase") + "{p}{e}",
        			caller: id,
        			gui: true
        		})
            })
            cutscene_wait_until(function() {
                return !instance_exists(o_text_typer)
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