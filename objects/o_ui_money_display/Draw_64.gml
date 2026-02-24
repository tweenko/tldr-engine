var xx = 0
if instance_exists(get_leader()) {
    if get_leader().x > guipos_x() + 160
        xx += 320
}

var held_space = item_get_maxcount(sell_type) - item_get_count(sell_type)
var storage_space = item_get_maxcount(ITEM_TYPE.STORAGE) - item_get_count(ITEM_TYPE.STORAGE)

var y_off = (sell_type != ITEM_TYPE.CONSUMABLE ? 26 : 0)

ui_dialoguebox_create(352 + xx, 196 + y_off, 250, 79 + (sell_type == ITEM_TYPE.CONSUMABLE ? 26 : 0))

draw_set_font(loc_font("main"))
draw_set_colour(c_white)

draw_text_transformed(368 + xx, 208 + y_off, $"${save_get("money")}", 2, 2, 0)
draw_text_transformed(368 + xx, 234 + y_off, string(loc("money_display_held_space"), held_space), 2, 2, 0)

if sell_type == ITEM_TYPE.CONSUMABLE
    draw_text_transformed(368 + xx, 260 + y_off, string(loc("money_display_storage_space"), storage_space), 2, 2, 0)