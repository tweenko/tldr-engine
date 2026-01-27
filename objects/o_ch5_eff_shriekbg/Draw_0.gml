/// @description Render BG
//draw_clear_alpha(#3b0048, image_alpha)
bg_inst.draw(guipos_x(), guipos_y(), true); // draw our BG
draw_sprite_ext(spr_pixel, 0, guipos_x(), guipos_y(), 320, 240, 0, c_black, 1 - image_alpha*.5)