save_load(target_save_index, global.chapter)
global.save.NAME = name

room_goto(save_get("room"))
fader_fade(1, 0, 15)
flash_fade(0, 0, 0) 

call_later(1, time_source_units_frames, function() {
    save_export(target_save_index)
    save_set(target_save_index)
})