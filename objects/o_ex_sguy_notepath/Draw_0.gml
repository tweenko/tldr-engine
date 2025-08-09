var temp_prog = clamp(round(prog * 10)/10, 0, 1)
var c = c_gray

for (var i = 0; i <= temp_prog; i += q/w) {
	var ww = 12
	var b = .002
    
	for (var j = 0; j < 4; ++j) {
		var col1=merge_color(c_red, c, clamp(-i+red,0,.5) * 2)
		var col2=merge_color(c_red, c, clamp(-(i+q/w)+red,0,.5) * 2)
		
		var o = (j/4*ww-4) * clamp(i, 0, .1) * 10
		var d = point_direction(path_get_x(path, i), path_get_y(path, i), 
            path_get_x(path, i+q/w), path_get_y(path, i+q/w)
        ) + 90
		
		var x1 = path_get_x(path, i) + lengthdir_x(o, d)
		var x2 = path_get_x(path, i + q/w + b) + lengthdir_x(o, d)
		
		var y1 = path_get_y(path, i) + lengthdir_y(o, d)
		var y2 = path_get_y(path, i + q/w + b) + lengthdir_y(o, d)
		
		draw_set_alpha(image_alpha)
        
		draw_line_color(x1, y1, x2, y2, col1, col2)
		if floor(i * w) % 18 == 0 
            draw_line_color(x1, y1, 
            path_get_x(path, i) - lengthdir_x(o, d), 
            path_get_y(path, i) - lengthdir_y(o, d),
            col1, col1
        )
		draw_set_alpha(1)
	}
}

draw_set_color(c_white)