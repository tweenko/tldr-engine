if instance_exists(target) {
    if follow_x {
        if climb_check() && x != target.x {
            var dist = target.x - x;
            var spd = lerp(.5, 2, clamp(abs(dist / 10), 0, 1)) * sign(dist);
            
            if abs(dist) < .5
                x = target.x;
            else 
                x += spd;
        }
        else
            x = target.x;
        
        x += offset_x;
        
        if confined_on_x
            x = camera_confine_x(x)
    }
    if follow_y {
        if climb_check() && y != target.y {
            var dist = target.y - y;
            var spd = lerp(.5, 2, clamp(abs(dist / 10), 0, 1)) * sign(dist);
            
            if abs(dist) < .5
                y = target.y;
            else 
                y += spd;
        }
        else
            y = target.y;
        
        y += offset_y;
        
        if confined_on_y
            y = camera_confine_y(y)
    }
}