if !surface_exists(surf) 
	surf = surface_create(640, 480)

surface_set_target(surf)

var __roll = lerp(80, 0, ui_main_lerp)

draw_clear_alpha(0,0)
draw_sprite_ext(spr_pixel, 0, 0, 417 - 92 + __roll, 640, 156, 0, c_black, 1)
draw_sprite_ext(spr_pixel, 0, 0, 417 - 92 + __roll, 640, 2, 0, bcolor, 1)

for (var i = 0; i < array_length(global.party_names); ++i) {
    var xoff = i*213 + 319.5 + array_length(global.party_names) * -213/2
    var box_base_y = 325 + __roll - 32 * party_ui_lerp[i]
    var member_name = global.party_names[i]
    
    draw_set_color(c_white)
    
    var col = bcolor
    if party_selection == i 
        col = party_getdata(member_name, "color")
    
    draw_sprite_ext(spr_pixel, 0, xoff, box_base_y, 213, 70, 0, c_black, 1)
    draw_sprite_ext(spr_pixel, 0, xoff, box_base_y, 213, 2, 0, col, 1)
    draw_sprite_ext(spr_pixel, 0, xoff, box_base_y + 37, 213, 2, 0, col, 1)
    
    if party_selection == i {
        draw_sprite_ext(spr_pixel, 0, xoff + 211, box_base_y, 2, 69, 0, col, 1)
        draw_sprite_ext(spr_pixel, 0, xoff, box_base_y, 2, 69, 0, col, 1)
    }
    
    // draw the icon
    if party_state[i] == PARTY_STATE.IDLE {
        var __icon = party_geticon(member_name)
        if party_hurt_timer[i] > 0
            __icon = party_geticon_hurt(member_name)
        
        draw_sprite_ext(__icon, 0, 12 + xoff, box_base_y + 11, 1, 1, 0, c_white, 1)
    }
    else {
        draw_sprite_ext(spr_ui_enc_icons_command, __state_to_icon(party_state[i]), 
            12 + xoff, 
            box_base_y + 11, 
            1, 1, 0, 
            party_getdata(member_name, "iconcolor"), 1
        )
    }
    
    // draw the name
    var __name = string_upper(party_getname(member_name, false))
    var __name_font = global.font_name[0]
    if string_length(__name) > 4
        __name_font = global.font_name[1]
    if string_length(__name) > 5
        __name_font = global.font_name[2]
    
    draw_set_font(__name_font)
    draw_text_transformed(51 + xoff, box_base_y + 11, __name, 1, 1, 0)
    
    // draw the hp bar
    var health_coeff = party_getdata(member_name, "hp") / party_getdata(member_name, "max_hp")
    var health_real = string(party_getdata(member_name, "hp"))
    var health_max = string(party_getdata(member_name, "max_hp"))
    
    draw_sprite_ext(spr_ui_hp_text, 0, 110 + xoff, box_base_y + 22, 1, 1, 0, c_white, 1)
    draw_sprite_ext(spr_pixel, 0, 128 + xoff, box_base_y + 22, 76, 9, 0, c_maroon, 1)
    draw_sprite_ext(spr_pixel, 0, 128 + xoff, box_base_y + 22, 76 * max(0, health_coeff), 9, 0, party_getdata(member_name, "color"), 1)
    
    draw_set_font(global.font_ui_hp)
    draw_set_halign(fa_right)
    
    if party_getdata(member_name, "hp") <= ui_hp_danger_zone
        draw_set_color(c_yellow)
    if !party_isup(member_name) 
        draw_set_color(c_red)
    
    draw_text_transformed(160 + xoff, box_base_y + 9, health_real, 1, 1, 0)
    draw_sprite_ext(spr_ui_hp_seperator, 0, 161 + xoff, box_base_y + 9, 1, 1, 0, c_white, 1)
    draw_text_transformed(205 + xoff, box_base_y + 9, health_max, 1, 1, 0)
    
    draw_set_halign(fa_left)
    draw_set_color(c_white)
    draw_set_font(loc_font("main"))
    draw_set_alpha(1)
    
    if !surface_exists(party_ui_button_surf[i])
        party_ui_button_surf[i] = surface_create(211, 33)
    surface_set_target(party_ui_button_surf[i]) {
        var button_order = party_buttons[i]
        draw_clear_alpha(0,0)
        
        draw_set_color(c_black)
        draw_rectangle(2, 30 * (1 - party_ui_lerp[i]), 2+211, 30, 0)
        draw_set_color(bcolor)
        draw_rectangle(2, 30, 2+210, 33, 0)
        draw_set_color(c_white)
        
        // image indexes
        gpu_set_colorwriteenable(1, 1, 1, 0)
        for (var j = 0; j < 3; ++j) {
            var xxoff = ui_party_sticks[j] * 2
            draw_set_color(merge_color(party_getdata(global.party_names[i], "color"), c_black, ui_party_sticks[j]/20))
            
            draw_rectangle(0 + xxoff, 0, 1 + xxoff, 29, 0)
            draw_rectangle(210 - xxoff, 0, 211 - xxoff, 29, 0)
        }
        
        draw_set_alpha(1)
        draw_set_color(c_white)
        
        for (var j = 0; j < array_length(button_order); ++j) {
            var __spr = __button_to_sprite(button_order[j])
            var __x_off = 111 - floor(array_length(button_order)*35/2) + j*35
            var __selection = party_button_selection[party_selection]
            
            draw_sprite_ext(spr_pixel, 0, __x_off, 1, 31, 25, 0, c_black, 1)
            if sprite_exists(__spr)
                draw_sprite_ext(__spr, (__selection == j && i == party_selection ? 1 : 0), __x_off, 1, 1, 1, 0, c_white, 1)
            
            if i == party_selection && __button_highlight(button_order[j], global.party_names[i]) && __selection != j {
                gpu_set_fog(true, c_white, 0, 1)
                draw_sprite_ext(__spr, 1, __x_off, 1, 1, 1, 0, c_white, .5 + sine(8, .3))
                gpu_set_fog(false, 0, 0, 0)
            }
        }
        
        gpu_set_colorwriteenable(1, 1, 1, 1)
    }
    surface_reset_target()
}

draw_sprite_ext(spr_pixel, 0, 0, 363 + __roll, 640, 156, 0, c_black, 1)
draw_sprite_ext(spr_pixel, 0, 0, 362 + __roll, 640, 3, 0, bcolor, 1)

for (var i = 0; i < array_length(global.party_names); i ++) { // draw buttons
    var xoff = i*213 + 319.5 + array_length(global.party_names) * -213/2
    if party_ui_lerp[i] > .1 && battle_state == BATTLE_STATE.MENU
        draw_surface(party_ui_button_surf[i], xoff, 332 + __roll)
}

surface_reset_target()

draw_surface_ext(surf, 0, 0, 1, 1, 0, c_white, 1)