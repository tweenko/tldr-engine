selection = 0
view = 0
page_max = 9

soul_x = 50
soul_y = 98 
soul_vx = soul_x
soul_vy = soul_y

timer = 0

__draw_charbox = function(xx, yy, color, sprite, name = undefined, chapter = undefined, level = undefined) {
    draw_rectangle(xx-1, yy-1, xx + 205+1, yy + 150+1, false)
    draw_rectangle_color(xx, yy, xx + 205, yy + 150, c_black, c_black, color, color, false)
    
    draw_sprite_ext(sprite, timer * (sprite_get_speed(sprite)/30), xx + 205/2, yy + 145, 2, 2, 0, c_white, 1)
    
    if !is_undefined(name) {
        draw_set_halign(fa_center)
        draw_text_transformed(xx + 205/2, yy + 165, name, 2, 2, 0)
        draw_set_halign(fa_left)
    }
    
    if !is_undefined(chapter)
        draw_text_transformed(xx - 2, yy + 205, $"CHAPTER {chapter}", 2, 2, 0)
    
    if !is_undefined(level) {
        draw_set_halign(fa_right)
        draw_text_transformed(xx + 205+1, yy + 205, $"LV {level}", 2, 2, 0)
    }
    
    draw_set_halign(fa_left)
}

if instance_exists(get_leader())
    get_leader().moveable_recruits = false