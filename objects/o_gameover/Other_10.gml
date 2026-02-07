/// @description load save

music_stop_all()
save_load(global.save_slot)
room_goto(save_get("room"))
instance_destroy()