if instance_exists(target) {
    if follow_x {
        x = target.x 
        x += offset_x
        
        if confined_on_x
            x = camera_confine_x(x)
    }
    if follow_y {
        y = target.y
        y += offset_y
        
        if confined_on_y
            y = camera_confine_y(y)
    }
}