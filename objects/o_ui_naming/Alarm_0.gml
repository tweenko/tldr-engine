save_load(target_save_index, global.chapter)
global.save.NAME = name

room_goto(save_get("room"))
fader_fade(1, 0, 15)
flash_fade(0, 0, 0) 