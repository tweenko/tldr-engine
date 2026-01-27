/// @description load save

save_load(global.save_slot)
room_goto(save_get("room"))
instance_destroy()