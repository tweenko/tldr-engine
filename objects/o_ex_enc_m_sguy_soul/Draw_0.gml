if !dropping{
	draw_set_color(c_red); 
    draw_set_alpha(.5)
	
	var dir = point_direction(x, y, xprevious, yprevious)
	
	x -= 1; y -= 1
	draw_line_width(x, y, x + lengthdir_x(20, dir), y + lengthdir_y(20, dir), 1)
	x += 1; y += 1
	
	draw_set_color(c_white); 
    draw_set_alpha(1)
}

draw_self()