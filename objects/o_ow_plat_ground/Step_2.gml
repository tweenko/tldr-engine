// Set Y
y = lerp(initial_y, initial_y + (tile_height*wall_distance), global.platforming_perspective)

// Set connected object's Y
if array_length(connected_instances_bg) > 0 {
    for (var i = 0; i < array_length(connected_instances_bg); i += 1){
        with connected_instances_bg[i] {
            if !variable_instance_exists(self, "initial_y") 
                initial_y = y;
            if !variable_instance_exists(self, "plat_ydifference") 
                plat_ydifference = y - other.ystart;
            
            y = lerp(initial_y, initial_y + (other.tile_height * other.wall_distance) - plat_ydifference, global.platforming_perspective);
            
            if global.platforming_perspective >= 1 && !(variable_instance_exists(id, "custom_platforming_depth") && custom_platforming_depth)
                depth = DEPTH_PLATFORMER.BACK2
				image_blend = merge_color(c_white, other.connected_instances_blend_bg, other.connected_instances_bmerge_bg * global.platforming_perspective) //This should probably be implemented like dodge_darken or lighting_darken; OR, make a custom draw_self which can add overlay sprites via a struct or arrays...
        }
    }
}

// Set depth
if !is_undefined(depth_platforming) && global.platforming_perspective > 0
    depth = depth_platforming;
else 
    depth = depth_start;

// Set collide
if global.platforming_perspective > 0
    collide = collide_while_plat;
else 
    collide = collide_ow;

// Set plathidden
if hide_while_not_plat 
    plathidden = global.platforming_perspective;