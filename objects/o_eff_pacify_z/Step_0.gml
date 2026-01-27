image_xscale += .1
image_yscale = image_xscale

image_alpha -= .1

if image_alpha <= 0
    instance_destroy()