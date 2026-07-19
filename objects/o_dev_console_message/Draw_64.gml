draw_sprite_ext(spr_pixel, 0, 0, 0, GAME_W_GUI, GAME_H_GUI, 0, c_black, .85);
draw_set_font(loc_font("main"));

drawer();

draw_set_halign(fa_center);
draw_set_alpha(.5);
input_binding_draw(INPUT_VERB.SELECT, 320, 480 - 20, 1, " to close the Message)", "(Press ");
draw_set_alpha(1);
draw_set_halign(fa_left);