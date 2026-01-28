save_load(target_save_index, global.chapter, true)
global.save.NAME = name
global.time = 0

room_goto(save_get("room"))
fader_fade(1, 0, 15)
flash_fade(0, 0, 0) 

call_later(1, time_source_units_frames, function() {
    save_export(target_save_index)
    save_set_slot(target_save_index)
})