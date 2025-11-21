if !instance_exists(o_enc_box_solid)
    exit

if place_meeting(x, y, o_enc_box_solid) {
    var inst = instance_place_list_ext(x, y, o_enc_box_solid, false)
    
    for (var i = 0; i < array_length(inst); i ++) {
        if !instance_exists(inst[i])
            continue
        
        with inst[i] {
            var da = move_da
            
            var dist = point_distance(other.x, other.y, x, y)
            var dir = point_direction(other.x, other.y, x, y) - image_angle
            var relative_xdiff = dcos(dir) * dist
            var relative_ydiff = dsin(dir) * dist
            
            if da != 0 {
                var _dx = other.x - x
                var _dy = other.y - y
                
                var _c = dcos(da)
                var _s = dsin(da)
                
                var _new_dx = (_dx * _c) + (_dy * _s)
                var _new_dy = (_dy * _c) - (_dx * _s)
                
                other.x = x + _new_dx
                other.y = y + _new_dy
            }
            
            var hor_scale_adj = 0
            var ver_scale_adj = 0
            
            if move_w != 0
                hor_scale_adj += (relative_xdiff > 0 ? -move_w/2 : move_w/2)
            if move_h != 0
                ver_scale_adj += (relative_ydiff > 0 ? -move_h/2 : move_h/2)
            
            other.x += move_dx + lengthdir_x(hor_scale_adj, image_angle) + lengthdir_x(ver_scale_adj, image_angle+90)
            other.y += move_dy + lengthdir_y(hor_scale_adj, image_angle) + lengthdir_y(ver_scale_adj, image_angle+90)
        }
    }
}