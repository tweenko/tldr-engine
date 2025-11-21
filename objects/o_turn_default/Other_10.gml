/// @description init
event_inherited()
show_debug_message(object_get_name(object_index))

__support_init_default()

if !am_support
    timer_end = 60