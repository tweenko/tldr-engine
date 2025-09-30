audio_emitter_free(emitter_sfx)
audio_emitter_free(emitter_music)

save_settings_update()

if font_exists(global.partyname_font_0)
	font_delete(global.partyname_font_0)
if font_exists(global.partyname_font_1)
	font_delete(global.partyname_font_1)
if font_exists(global.partyname_font_2)
	font_delete(global.partyname_font_2)
	
if font_exists(global.font_ui_hp)
	font_delete(global.font_ui_hp)
	
if font_exists(global.font_numbers_w)
	font_delete(global.font_numbers_w)
if font_exists(global.font_numbers_g)
	font_delete(global.font_numbers_g)