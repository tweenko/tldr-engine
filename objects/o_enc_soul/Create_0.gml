// the soul and box system made by jevilhumor (callum)

event_inherited();

depth = DEPTH_ENCOUNTER.SOUL;
image_alpha = 0;
image_index = 0;
image_speed = 0;
image_xscale = 0.5;
image_yscale = 0.5;
image_blend = c_red

i_frames = 0;
spd = 8
real_spd = 1

graze_buffer = 0;
inst_graze = instance_create_depth(x, y, depth - 10, o_enc_soul_grazer);
inst_aura = noone

is_transitioning = true;
transition_mode = 0;

color = 0
surf = 0
moving = false

canmove = true
outline = 0

alarm[0] = 1;