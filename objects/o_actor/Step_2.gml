if !is_in_battle 
	depth = -2000 - y
else 
	depth = DEPTH_ENCOUNTER.ACTORS - (y - guipos_y())

if !is_undefined(customdepth)
	depth = customdepth

// record the sliding states
prevsliding = sliding