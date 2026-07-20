draw_sprite_ext(spr_pixel, 0, 0, 0, GAME_W_GUI, GAME_H_GUI, 0, c_black, .85)
draw_set_font(loc_font("main"))

var yy = 50
for (var i = 0; i < array_length(display_list); i ++) {
    if array_length(display_list[i].items) == 0
        continue;
    
    draw_set_colour(merge_colour(display_list[i].color, c_white, .5))
    draw_text_transformed_shadow(25, yy - scroll, $"{display_list[i].name}", 1, 1, 0, 2, c_black)
    draw_set_colour(c_white)
    
    yy += 20
    
    for (var j = 0; j < array_length(display_list[i].items); j ++) {
        if selection == j && category == i
            arrow_y = yy + 5;
        
        var i_name = _item_name(display_list[i].items[j], i, j);
        draw_set_colour(array_contains(item_blocked, display_list[i].items[j]) ? c_gray : c_white);
        draw_text_highlighted(i_name, 35, yy - scroll, (selection == j && category == i && !search_mode));
        draw_set_colour(c_white);
        
        // highlight overlap
        if search_mode {
            var pos = string_pos(search_input, i_name);
            var string_prepos = string_copy(i_name, 0, pos-1);
            
            draw_sprite_ext(spr_pixel, 0, 35 + string_width(string_prepos), yy - scroll, string_width(search_input), string_height(i_name), 0, c_white, .2);
        }
        
        yy += 20;
    }
}

var searchbar_text = search_input;
var searchbar_text_isplaceholder = (string_length(search_input) == 0);

if searchbar_text_isplaceholder
    searchbar_text = "Search";

var searchbar_height = 30;
var searchbar_width = string_width(searchbar_text) + (searchbar_height/2 + 12 + 16);
var searchbar_padding = 12;
var searchbar_typer_offset = 7;

draw_sprite_ext(spr_pixel, 0, 0, 0, GAME_W_GUI, searchbar_height + searchbar_padding*2, 0, c_black, .85)
draw_sprite_ext(spr_pixel, 0, 25, searchbar_padding, searchbar_width, searchbar_height, 0, c_dkgray, .5)

if search_mode
    draw_rectangle_outline(25, searchbar_padding, searchbar_width, searchbar_height, 1,, c_gray);

draw_sprite_ext(spr_ui_search_icon, 0, 25 + searchbar_height/2, searchbar_padding + searchbar_height/2, 1, 1, 0, c_gray, 1);

draw_set_colour((searchbar_text_isplaceholder ? c_gray : c_white));
draw_text_transformed(25 + searchbar_height/2 + 12, searchbar_padding + searchbar_typer_offset, searchbar_text, 1, 1, 0);
draw_set_colour(c_white);

if search_mode {
    var show = (search_cursor_timer div 10) % 2 == 0;
    draw_sprite_ext(spr_pixel, 0, 25 + searchbar_height/2 + 12 + (searchbar_text_isplaceholder ? 0 : string_width(searchbar_text) + 2), searchbar_padding + searchbar_typer_offset + 2, 1, 12, 0, c_white, (show ? 1 : 0));
}