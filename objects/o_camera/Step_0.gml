if instance_exists(target) {
    if climb_check()
        climb_mode = true;
    else if climb_mode {
        trans_from_climb_x = true;
        trans_from_climb_y = true;
        climb_mode = false;
    }
    
    if follow_x {
        if (climb_mode || trans_from_climb_x) {
            var dist = target.x - x;
            
            var d = abs(dist / 20);
            d = clamp(d, 0, (d >= 2 ? 5 : 2));
            
            var spd = lerp(.5, 2, d) * sign(dist);
            
            if abs(dist) < .5
                x = target.x;
            else 
                x += spd;
        }
        else
            x = target.x;
        
        if trans_from_climb_x && (x == target.x || x + o_camera.width/2 >= room_width || x - o_camera.width/2 <= 0)
            trans_from_climb_x = false;
        
        x += offset_x;
        
        if confined_on_x
            x = camera_confine_x(x);
    }
    if follow_y {
        if (climb_mode || trans_from_climb_y) {
            var dist = target.y - y;
            var spd = lerp(.5, 2, clamp(abs(dist / 20), 0, 1)) * sign(dist);
            
            if abs(dist) < .5
                y = target.y;
            else 
                y += spd;
        }
        else
            y = target.y;
        
        if trans_from_climb_y  && (y == target.y || y + o_camera.height/2 >= room_height || y - o_camera.height/2 <= 0)
            trans_from_climb_y = false;
        
        y += offset_y;
        
        if confined_on_y
            y = camera_confine_y(y);
    }
}