/// @description load save

music_stop_all()

global.saves = save_read_all() // saves saved on device
if global.saves[global.save_slot] != -1 
    global.save = global.saves[global.save_slot]
save_load(global.save_slot)

room_goto(save_get("room"))
instance_destroy()