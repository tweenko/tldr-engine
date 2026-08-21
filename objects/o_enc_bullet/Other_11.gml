/// @description draw
if color == BULLET_COLOR.BLUE
	image_blend = c_aqua
if color == BULLET_COLOR.ORANGE
	image_blend = c_orange

if (gui)
	if (inside)
		gui = false; // can't be inside and gui at the same time
	else
		depth = DEPTH_ENCOUNTER.UI; // makes the bullet above the UI if it's GUI

if !(gui)
	draw_self()