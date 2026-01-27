event_inherited()

drawer = function(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha) {
    draw_sprite_ext(spr_ow_shortcut_door_fire, o_world.frames * (2/15), x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha)
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha)
}

room_list = []
room_name_list = [] // the items inside will be run through loc

if room_exists(room_1) {
    array_push(room_list, room_1)
    array_push(room_name_list, room_1_name)
}
if room_exists(room_2) {
    array_push(room_list, room_2)
    array_push(room_name_list, room_2_name)
}
if room_exists(room_3) {
    array_push(room_list, room_3)
    array_push(room_name_list, room_3_name)
}