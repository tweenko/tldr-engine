image_alpha = lerp(start_alpha, end_alpha, timer/life);
image_xscale = lerp(start_scale, target_scale, timer/life);
image_yscale = image_xscale;

if timer > life
    instance_destroy();

timer ++;