event_inherited();

if !is_undefined(hovered_item) {
    var cat_color = display_list[category].color;
    
    draw_set_alpha(clamp((hover_timer - 3)/10, 0, 1));
    draw_set_font(loc_font("main"));
    
    // name
    var icon = hovered_item.icon;
    if !is_undefined(icon) && sprite_exists(hovered_item.icon)
        draw_sprite_ext(icon, 0, 320 - sprite_get_width(icon)*2 - 6, 46, 2, 2, 0, draw_get_color(), draw_get_alpha());
    
    draw_text_transformed_shadow(320, 42, item_get_name(hovered_item), 2, 2, 0, 1, c_black);
    
    draw_set_colour(merge_colour(c_white, cat_color, .5));
    
    draw_text_transformed(320, 42 + 40, item_get_type_name(item_get_type(hovered_item)), 1, 1, 0);
    draw_text_ext_transformed(320, 42 + 80, string_truncate_words(item_get_desc(hovered_item), 100), 20, 280, 1, 1, 0);
    
    draw_set_colour(c_white);
    
    switch item_get_type(hovered_item) {
        case ITEM_TYPE.WEAPON:
        case ITEM_TYPE.ARMOR:
            item_draw_diff_board(hovered_item, 320, 42 + 160)
    }
    
    draw_set_alpha(1);
}