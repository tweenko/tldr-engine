music_stop_all()

save_load(target_save_index, global.chapter,, true)
global.save.NAME = name
global.time = 0

room_goto(save_get("room"))
fader_fade(1, 0, 15)
flash_fade(0, 0, 0) 