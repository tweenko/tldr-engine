event_inherited()

if timer > 30 
    image_alpha -= .1

timer ++
if image_alpha <= 0 
    instance_destroy()