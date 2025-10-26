if instance_exists(target) {
	x = target.x
    y = target.y
    
    x += offset_x
    y += offset_y
    
    if confined_on_x
        x = camera_confine_x(x)
    if confined_on_y
        y = camera_confine_y(y)
}