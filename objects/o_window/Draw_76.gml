if !global.border
    exit

var screen_w = window_get_fullscreen() ? display_get_width() : window_get_width()
var screen_h = window_get_fullscreen() ? display_get_height() : window_get_height()

if screen_w == 0 || screen_h == 0
    exit

if !surface_exists(surf_border)
    surf_border = surface_create(screen_w, screen_h)