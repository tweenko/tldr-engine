draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, c_black, .85)
draw_set_font(loc_font("main"))

var yy = 10
for (var i = 0; i < array_length(display_list); i ++) {
    draw_set_colour(merge_colour(display_list[i].color, c_white, .5))
    draw_text_transformed_shadow(25, yy - scroll, $"{display_list[i].name}", 1, 1, 0, 2, c_black)
    draw_set_colour(c_white)
    
    yy += 20
    
    for (var j = 0; j < array_length(display_list[i].items); j ++) {
        var i_name = item_name(display_list[i].items[j], i, j)
        if selection == j && category == i {
            draw_sprite_ext(spr_ui_soul, 0, 20, yy + 5 - scroll, 1, 1, 0, c_red, 1)
            soul_y = yy + 5
        }
        
        var col = c_white
        if array_contains(item_blocked, display_list[i].items[j]) 
            col = c_gray
        
        draw_text_scale($"{i_name}", 35, yy - scroll, 1, col, 1)
        
        yy += 20
    }
}