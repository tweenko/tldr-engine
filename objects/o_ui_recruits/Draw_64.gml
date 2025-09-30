var recruit_array = global.recruits
var __page = selection div page_max
var __page_max = min(array_length(recruit_array), page_max * __page + page_max)
var __morepages = (array_length(recruit_array) > page_max)
var __total_pages = ceil(array_length(recruit_array) / page_max)

draw_set_font(loc_font("main"))

if view == 0 {
    ui_dialoguebox_create(30, 10, 620 - 30 - 1, 440 - 10 - 1, WORLD_TYPE.LIGHT)
    draw_text_transformed(80, 30, loc("recruits_title"), 2, 2, 0)
    
    draw_set_color(c_lime)
    draw_text_transformed(270, 30, loc("recruits_title_progress"), 1, 2, 0)
    draw_set_color(c_white)
    
    
    for (var i = __page*page_max; i < __page_max; i ++) {
        if selection == i
            draw_set_color(c_yellow)
        draw_text_transformed(80, 92 + (i - __page*page_max) * 35, loc(recruit_array[i].name), 2, 2, 0)
        
        if recruit_array[i].progress >= recruit_array[i].need {
            draw_set_color(c_lime)
            draw_text_transformed(275, 92 + (i - __page*page_max) * 35, loc("recruits_recruited"), 1, 2, 0)
        }
        else {
            draw_set_color(c_ltgray)
            draw_text_transformed(275, 92 + (i - __page*page_max) * 35, $"{recruit_array[i].progress}/{recruit_array[i].need}", 2, 2, 0)
        }
        
        draw_set_color(c_white)
    }
    
    // the display for the character
    var current_recruit = recruit_array[selection]
    __draw_charbox(370, 75, current_recruit.bgcolor, current_recruit.sprite, loc(current_recruit.name), current_recruit.chapter, current_recruit.level)
    
    input_binding_draw(INPUT_VERB.SELECT, 370 + 10, 75 + 245, 2, loc("recruits_more_msg"))
    input_binding_draw(INPUT_VERB.CANCEL, 370 + 10, 75 + 275, 2, loc("recruits_quit_msg"))
    
    if __morepages {
        draw_sprite_ext(spr_ui_arrow_flat, 0, 620 + round(sine(8, 3)), 240, 2, 2, 0, c_white, 1)
        draw_sprite_ext(spr_ui_arrow_flat, 0, 30 - round(sine(8, 3)), 240, -2, 2, 0, c_white, 1)
    }
    
}
else if view == 1 {
    ui_dialoguebox_create(30, 10, 610 - 30 - 1, 450 - 10 - 1, WORLD_TYPE.LIGHT)
    
    var current_recruit = recruit_array[selection]
    __draw_charbox(80, 70, current_recruit.bgcolor, current_recruit.sprite)
    
    draw_text_transformed(300, 30, $"CHAPTER {current_recruit.chapter}", 1, 2, 0)
    draw_set_halign(fa_right)
    draw_text_transformed(588, 30, $"{selection + 1}/{array_length(recruit_array)}", 1, 2, 0)
    
    draw_set_halign(fa_left)
    draw_text_transformed(300, 70, loc(current_recruit.name), 2, 2, 0)
    
    draw_set_font(loc_font("enc"))
    draw_text_ext_transformed(301, 121, loc(current_recruit.desc), 20, 280, 1, 1, 0)
    
    draw_set_font(loc_font("main"))
    draw_text_xfit(80, 240, loc("recruits_like"), 160, 2, 2)
    draw_text_xfit(180, 240, loc(current_recruit.like), 540, 2, 2)
    
    draw_text_xfit(80, 280, loc("recruits_dislike"), 160, 2, 2)
    draw_text_xfit(180, 280, loc(current_recruit.dislike), 540, 2, 2)
    
    draw_text_xfit(80, 320, "?????", 160, 2, 2)
    draw_text_xfit(180, 320, "?????????", 540, 2, 2)
    
    draw_text_xfit(80, 360, "?????", 160, 2, 2)
    draw_text_xfit(180, 360, "?????????", 540, 2, 2)
    
    
    draw_set_halign(fa_right)
    
    draw_text_transformed(560, 240, loc("recruits_level"), 1, 2, 0)
    draw_text_transformed(590, 240, loc(current_recruit.level), 1, 2, 0)

    draw_text_transformed(560, 280, loc("recruits_attack"), 1, 2, 0)
    draw_text_transformed(590, 280, loc(current_recruit.attack), 1, 2, 0)

    draw_text_transformed(560, 320, loc("recruits_defense"), 1, 2, 0)
    draw_text_transformed(590, 320, loc(current_recruit.defense), 1, 2, 0)
    
    draw_text_transformed(590, 360, $"{loc("recruits_element")} {current_recruit.element}", 1, 2, 0)
    
    draw_set_halign(fa_left)
    input_binding_draw(INPUT_VERB.CANCEL, 80, 400, 2, loc("recruits_return_msg")[0], loc("recruits_return_msg")[1])
    
    if __morepages {
        draw_sprite_ext(spr_ui_arrow_flat, 0, 610 + round(sine(8, 3)), 240, 2, 2, 0, c_white, 1)
        draw_sprite_ext(spr_ui_arrow_flat, 0, 30 - round(sine(8, 3)), 240, -2, 2, 0, c_white, 1)
    }
}

draw_sprite_ext(spr_uisoul, 0, soul_vx, soul_vy, 1, 1, 0, c_red, 1)