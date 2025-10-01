audio_emitter_free(emitter_sfx)
audio_emitter_free(emitter_music)

if progress {
    save_settings_update()
    
    if font_exists(global.font_name[0])
    	font_delete(global.font_name[0])
    if font_exists(global.font_name[1])
    	font_delete(global.font_name[1])
    if font_exists(global.font_name[2])
    	font_delete(global.font_name[2])
    	
    if font_exists(global.font_ui_hp)
    	font_delete(global.font_ui_hp)
    	
    if font_exists(global.font_numbers_w)
    	font_delete(global.font_numbers_w)
    if font_exists(global.font_numbers_g)
    	font_delete(global.font_numbers_g)
}