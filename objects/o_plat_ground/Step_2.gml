// Set Y
y = lerp(initial_y, initial_y + (tile_height*wall_distance), global.platforming_perspective)

// Set connected object's Y
if array_length(connected_instances) > 0 {
    for (var i = 0; i < array_length(connected_instances); i += 1){
        with connected_instances[i]{
            if !variable_instance_exists(self, "initial_y") 
                initial_y = y;
            if !variable_instance_exists(self, "plat_ydifference") 
                plat_ydifference = y - other.y;
            
            //image_blend = c_red
            y = lerp(initial_y, initial_y + (other.tile_height * other.wall_distance) - plat_ydifference, global.platforming_perspective);
            
            if global.platforming_perspective >= 1 
                depth = DEPTH_PLATFORMER.BACK2
                
            //issue: not accounting for negative wall distance
        }
    }
}

// Set depth
//depth = DEPTH_PLATFORMER.PLAT-y

// Set collide
if global.platforming_perspective > 0 
    collide = collide_while_plat;
else 
    collide = collide_ow;

// Set plathidden
if hide_while_not_plat 
    plathidden = global.platforming_perspective;