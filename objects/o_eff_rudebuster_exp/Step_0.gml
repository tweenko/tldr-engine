direction = image_angle

image_xscale = lerp(image_xscale, 0, .2)
image_alpha -= .02

if image_alpha <= 0
    instance_destroy()
if image_xscale <= 0
    instance_destroy()