depth = (is_in_battle ? DEPTH_ENCOUNTER.ACTORS - (y - guipos_y()) : -2000 - y)
depth = (is_real(depth_override) ? depth_override : depth)

// record the sliding states
prevsliding = sliding