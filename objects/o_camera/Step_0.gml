image_xscale = width * scale_x;
image_yscale = height * scale_y; 

if instance_exists(target) {
    if follow_x {
        if climb_check() {
            var dist = target.x - x_real;
            
            var d = abs(dist / 40);
            d = clamp(d, 0, 1);
            
            var spd = lerp(.5, 8, d) * sign(dist);
            var diff_dist = abs(dist) - abs(spd);
            
            if diff_dist < abs(spd)
                x = target.x;
            else 
                x = x_real + spd;
        }
        else if global.platforming_perspective > .5
            x = target.x;
        else
            x = target.x;
        
        x += offset_x;
        
        x_real = x; // save the real value before confining it
        if confined_on_x
            x = camera_confine_x(x);
    }
    if follow_y {
        if climb_check() {
            var dist = target.y - y_real;
            
            var d = abs(dist / 40);
            d = clamp(d, 0, 1);
            
            var spd = lerp(.5, 8, d) * sign(dist);
            var diff_dist = abs(dist) - abs(spd);
            
            if diff_dist < abs(spd)
                y = target.y;
            else 
                y = y_real + spd;
        }
        else if global.platforming_perspective > .5
            y = target.y;
        else
            y = target.y;
        
        y += offset_y;
        
        y_real = y; // save the real value before confining it
        if confined_on_y
            y = camera_confine_y(y);
    }
}
else {
    x_real = x;
    y_real = y;
}