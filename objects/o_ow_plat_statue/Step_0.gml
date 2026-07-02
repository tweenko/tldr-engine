// Depth
if global.platforming_perspective > 0 
    depth = DEPTH_PLATFORMER.BACK2;

// Draw back light
shinetimer ++;
if global.platforming_perspective > 0.5 and can_hit
    shinealpha += 0.1;
else
    shinealpha -= 0.1;