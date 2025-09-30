image_alpha = 1 - (timer/life)
image_xscale = lerp(start_scale, target_scale, timer/life)
image_yscale = image_xscale

if timer > life
    instance_destroy()

timer ++