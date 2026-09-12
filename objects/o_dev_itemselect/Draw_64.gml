event_inherited();

if !is_undefined(hovered_item) {
    var cat_color = display_list[category].color;
    var cat_color_mellow = merge_colour(cat_color, c_white, .5);
    var cat_color_highlight = merge_colour(cat_color, c_white, .75);
    
    draw_set_alpha(clamp((hover_timer - 3)/10, 0, 1));
    draw_set_font(loc_font("main"));
    
    // name
    var icon = hovered_item.icon;
    if !is_undefined(icon) && sprite_exists(hovered_item.icon)
        draw_sprite_ext(icon, 0, 320 - sprite_get_width(icon)*2 - 6, 46, 2, 2, 0, draw_get_color(), draw_get_alpha());
    
    draw_set_colour(c_black);
    draw_text_transformed(320+2, 42+2, item_get_name(hovered_item), 2, 2, 0);
    draw_set_colour(c_white);
    draw_text_transformed_colour(320, 42, item_get_name(hovered_item), 2, 2, 0, c_white, c_white, cat_color_highlight, cat_color_highlight, draw_get_alpha());
    
    draw_set_colour(cat_color_mellow);
    
    draw_text_transformed(320, 42 + 34, item_get_type_name(item_get_type(hovered_item)), 1, 1, 0);
    
    var _y = 42 + 80;
    var _first_text = item_get_desc(hovered_item, ITEM_DESC_TYPE.FULL);
    var _second_text = item_get_desc(hovered_item, ITEM_DESC_TYPE.SHORTENED);
    
    var _desc_text = string_truncate_words(string_remove_newlines(_first_text), 100);
    draw_text_ext_transformed(320, _y, _desc_text, 20, 280, 1, 1, 0); // replace with typer parser when new text typer is done
    _y += string_height_ext(_desc_text, 20, 280) + 30;
    
    if _first_text != _second_text {
        _desc_text = string_truncate_words(string_remove_newlines(item_get_desc(hovered_item, ITEM_DESC_TYPE.SHORTENED)), 50);
        draw_text_ext_transformed(320, _y, _desc_text, 20, 280, 1, 1, 0); // replace with typer parser when new text typer is done
        _y += string_height_ext(_desc_text, 20, 280) + 30;
    }
    
    draw_set_colour(c_white);
    
    switch item_get_type(hovered_item) {
        case ITEM_TYPE.WEAPON:
        case ITEM_TYPE.ARMOR:
            var xx = 320;
            var yy = 42 + 50;
            var save_alpha = draw_get_alpha();
            
            draw_set_colour(cat_color_mellow);
            draw_set_alpha(save_alpha/2);
            
            // draw ability
            if !is_undefined(hovered_item) && !is_undefined(hovered_item.effect) {
                draw_set_alpha(save_alpha);
                
                if sprite_exists(hovered_item.effect.sprite)
                    draw_sprite_ext(hovered_item.effect.sprite, 0, xx - 13, yy + 3, 1, 1, 0, draw_get_color(), draw_get_alpha())
                draw_text_transformed(xx, yy, hovered_item.effect.text, 1, 1, 0);
            }
            else
                draw_text_transformed(xx, yy, loc("menu_no_ability"), 1, 1, 0);
            
            draw_set_colour(c_white);
            draw_set_alpha(save_alpha);
            
            item_draw_diff_board(hovered_item, 320, _y);
            break;
    }
    
    draw_set_alpha(1);
}