depth = -2000-y;
if global.platforming_perspective > 0 
    depth = DEPTH_PLATFORMER.ACTORS;

if is_in_battle and instance_exists(o_eff_bg) /*and o_eff_bg.alphain == true*/ {
    depth = DEPTH_ENCOUNTER.ACTORS - (y - guipos_y())
}
if is_real(depth_override) 
    depth = depth_override;

// record the sliding states
prevsliding = sliding;

// get the last dirs up/down and left/right
var dirM = cap_wraparound(360 - point_direction(xprevious, yprevious, x, y) + 90, 360);
if y != yprevious {
	if dirM < 85 or dirM > 275 last_dir_up_down = DIR.UP;
	if dirM > 95 and dirM < 265 last_dir_up_down = DIR.DOWN;
}
if x != xprevious {
	if dirM > 5 and dirM < 175 last_dir_left_right = DIR.RIGHT;
	if dirM > 185 and dirM < 355 last_dir_left_right = DIR.LEFT;
}