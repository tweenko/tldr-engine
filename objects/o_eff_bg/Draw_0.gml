xx = guipos_x();
yy = guipos_y();

// Background
draw_set_color(bg_clear_color);
draw_set_alpha(image_alpha * bg_clear_alpha);
draw_rectangle(-100, -100, room_width + 100, room_height + 100, false);
draw_set_color(c_white);
draw_set_alpha(1);
if !surface_exists(bg_surface)
	bg_surface = surface_create(320 * 2, 240 * 2);
surface_set_target(bg_surface);
bg_draw();
surface_reset_target();
bg_surface_draw();

// Bullet Darkness
if !surface_exists(bg_bulletdark_surface) 
	bg_bulletdark_surface = surface_create(320 * 2, 240 * 2);
surface_set_target(bg_bulletdark_surface);
draw_clear_alpha(bg_bulletdark_clear_color, bg_bulletdark_clear_alpha);
bg_bulletdark_draw();
surface_reset_target();
bg_bulletdark_surface_draw();

