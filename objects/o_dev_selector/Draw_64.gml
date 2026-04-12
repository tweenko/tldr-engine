draw_sprite_ext(spr_pixel, 0, 0, 0, GAME_W_GUI, GAME_H_GUI, 0, c_black, .85)
draw_set_font(loc_font("main"))

var yy = 10
for (var i = 0; i < array_length(display_list); i ++) {
    draw_set_colour(merge_colour(display_list[i].color, c_white, .5))
    draw_text_transformed_shadow(25, yy - scroll, $"{display_list[i].name}", 1, 1, 0, 2, c_black)
    draw_set_colour(c_white)
    
    yy += 20
    
    for (var j = 0; j < array_length(display_list[i].items); j ++) {
        if selection == j && category == i
            arrow_y = yy + 5;

        var i_name = item_name(display_list[i].items[j], i, j);
        


        draw_set_colour(array_contains(item_blocked, display_list[i].items[j]) ? c_gray : c_white);
        draw_text_highlighted(i_name, 35, yy - scroll, (selection == j && category == i));
        draw_set_colour(c_white);
        
        yy += 20;
    }
}