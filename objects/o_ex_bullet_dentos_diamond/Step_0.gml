direction += 2

image_angle = direction + 90

image_xscale = lerp(image_xscale, 1, .1)

if timer > 50
    image_alpha -= .1

timer ++