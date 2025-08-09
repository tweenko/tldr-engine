// the soul and box system is by jevilhumor (callum)

// internal
temp_angle = -180;
temp_scale = 1;

surface_board = -1;
bullet_surf = -1

is_sprite = false;
sprite = -1;
is_transitioning = false;
transition_mode = 0;

x = 321/2;
y = 171/2;
depth = DEPTH_ENCOUNTER.BOX;

for(var i = 0; i < 15; i++) {
	rem_angle[i] = 0;
	rem_scale[i] = 0;
	rem_alpha[i] = 0;
}
trans_frame = 0;

// customizable
width = 75;
height = 75;
color = c_green;
flash = 0

temp_scale = 0

x += guipos_x()
y += guipos_y()

alarm[0] = 1;