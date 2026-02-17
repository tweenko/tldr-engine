ui_dialoguebox_create(8, 248, 400, 225)
ui_dialoguebox_create(408, 248, 225, 225)

draw_set_font(loc_font("main"))

if menu_in_options {
    for (var i = 0; i < array_length(shop_data.options); i ++) {
        if option_selection == i
            draw_sprite_ext(spr_uisoul, 0, 450, 270 + 40*i, 1, 1, 0, c_red, 1)
        
        draw_set_colour(shop_data.options[i].color)
        draw_text_transformed(480, 260 + 40*i, shop_data.options[i].name, 2, 2, 0)
        draw_set_colour(c_white)
    }
}

draw_text_transformed(440, 420, $"${save_get("money")}", 2, 2, 0)

if !menu_in_options && is_callable(menu_drawer)
    menu_drawer()