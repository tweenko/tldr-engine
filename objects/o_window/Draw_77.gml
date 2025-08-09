var SW = (window_get_fullscreen() ? display_get_width() : window_get_width());
var SH=  (window_get_fullscreen() ? display_get_height() : window_get_height());
var SX = SW / 640;
var SY = SH / 480;
var SF = min(SX, SY);

var divide = 480
if display_get_width() < display_get_height() {
	divide = 640
}

var xoff = sine(10, sinexoff) + random_range(-shake, shake) * SF
var yoff = sine(10, sineyoff) + random_range(-shake, shake) * SF

gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);

display_set_gui_maximize(SF, SF, (SW-640*SF)/2 + xoff, (SH-480*SF)/2 + yoff);
draw_surface_ext(application_surface, 
	(SW-960*SF) / 2 + 160*SF + xoff, (SH-540*SF) / 2 + 30*SF + yoff,
	SF, SF, 0, c_white,1
);
gpu_set_blendmode(bm_normal);