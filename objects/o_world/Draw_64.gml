if incompatible_save_warning {
    var __coeff = 1 - incompatible_save_sleep/20
    var __c = lerp_type(30, 0, __coeff, "cubic_out")
    
    draw_set_font(loc_font("main"))
    draw_set_alpha(__coeff * incompatible_alpha)
    
    draw_set_halign(fa_center)
    draw_set_color(c_aqua)
    draw_text_transformed(320, 120 + __c, "WARNING!", 2, 2, 0)
    
    draw_set_color(c_white)
    draw_text_transformed(320, 160 + __c, "Your Save File was recorded\non an older version of the engine.\nIt's highly recommended to clear your SAVE DATA.\nThe game will be closed once you select an option.", 1, 1, 0)
    
    draw_set_color(c_aqua)
    draw_text_transformed(320, 250 + __c, "Would you like to clear your SAVE DATA?\n(It will be impossible to recover)", 1, 1, 0)
    
    draw_sprite_ext(spr_ui_soul, 0, incompatible_soulx, 303 + __c, 1, 1, 0, c_red, incompatible_alpha)
    
    draw_set_color(c_white)
    if incompatible_selection == 0
        draw_set_color(c_yellow)
    draw_text_transformed(320 - 50, 300 + __c, "Yes", 1, 1, 0)
    
    draw_set_color(c_white)
    if incompatible_selection == 1
        draw_set_color(c_yellow)
    draw_text_transformed(320 + 60, 300 + __c, "No", 1, 1, 0)
    
    draw_set_color(c_gray)
    draw_text_transformed(320, 400 + __c, $"Local Save Version: {(struct_exists(global.settings, "VERSION_SAVED") ? global.settings.VERSION_SAVED : "???")}\nEngine Version: {ENGINE_VERSION}\nLast Compatible Version: {ENGINE_LAST_COMPATIBLE_VERSION}", 1, 1, 0)
    
    draw_set_color(c_white)
    draw_set_halign(fa_left)
    draw_set_alpha(1)
}