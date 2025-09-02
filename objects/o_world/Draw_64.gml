if incompatible_save_warning {
    var __coeff = 1 - incompatible_save_sleep/20
    var __c = lerp_type(30, 0, __coeff, "cubic_out")
    
    draw_set_font(loc_font("main"))
    draw_set_alpha(__coeff)
    
    draw_set_halign(fa_center)
    draw_set_color(c_aqua)
    draw_text_transformed(320, 180 + __c, "WARNING!", 2, 2, 0)
    
    draw_set_color(c_white)
    draw_text_transformed(320, 220 + __c, "Your Save File was recorded\non an older version of the engine.\nIf you wish to proceed, you\nmay find bugs and issues.", 1, 1, 0)
    
    draw_set_color(c_gray)
    draw_text_transformed(320, 400 + __c, $"Local Save Version: {(struct_exists(global.settings, "VERSION_SAVED") ? global.settings.VERSION_SAVED : "???")}\nEngine Version: {ENGINE_VERSION}\nLast Compatible Version: {ENGINE_LAST_COMPATIBLE_VERSION}", 1, 1, 0)
    
    draw_set_color(c_white)
    draw_set_halign(fa_left)
    draw_set_alpha(1)
}