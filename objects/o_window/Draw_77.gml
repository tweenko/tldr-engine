var screen_w = window_get_fullscreen() ? display_get_width() : window_get_width()
var screen_h = window_get_fullscreen() ? display_get_height() : window_get_height()
var scale = window_get_fullscreen() ? o_world.fullscreen_scale : o_world.window_scale

if window_get_fullscreen() && !global.border {
    scale = min(display_get_width() / 640, display_get_height() / 480)
}

if screen_w == 0 || screen_h == 0 {
    draw_clear(c_black)
    exit
}

var total_shake = shake

var xoff = sine(10, sinexoff) + random_range(-total_shake, total_shake) * scale
var yoff = sine(10, sineyoff) + random_range(-total_shake, total_shake) * scale

var xx = screen_w/2
var yy = screen_h/2

gpu_set_blendmode(bm_normal)
draw_clear(c_black)
display_set_gui_maximize(scale, scale, xx + xoff - 640/2*scale, yy + yoff - 480/2*scale)

gpu_set_blendenable(false)
draw_surface_ext(application_surface, 
    xx + xoff - 640/2*scale, yy + yoff - 480/2*scale, 
    scale, scale, 
    0, c_white, 1
)
gpu_set_blendenable(true)