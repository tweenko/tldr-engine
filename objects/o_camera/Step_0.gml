if instance_exists(target) {
	x = target.x
    y = target.y
    
    x += offset_x
    y += offset_y
    
    x = camera_confine_x(x)
    y = camera_confine_y(y)
}