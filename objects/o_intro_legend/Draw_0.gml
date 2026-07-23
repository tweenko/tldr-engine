if !active 
    exit

draw_set_alpha(picAlpha);
draw_sprite_part(pic, picIndex, -picXOff, -picYOff, picW, picH, picX, picY);
draw_set_alpha(1);

if sprite_exists(ov) {
    draw_set_alpha(ovAlpha);
    draw_sprite_part(ov, ovIndex, 0, -ovYOff, sprite_get_width(ov), ovH, ovX, ovY);
    draw_set_alpha(1);
}

draw_sprite_ext(spr_pixel, 0, 0, 0, GAME_W, GAME_H, 0, c_white, fadeWhiteAlpha);