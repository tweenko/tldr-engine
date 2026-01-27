/// @description draw
draw_set_font(font)

if god { //thanks toby
	shadow = false
	
	var xx = x+xoff
	var yy = y+yoff
	var mychar = symbol
	var specfade = image_alpha
	var ox = scalex
	var oy = scaley
	
	draw_set_alpha((1 * specfade))
    draw_set_alpha(((0.3 + (sin((timer / 14)) * 0.1)) * specfade))
    draw_text_transformed((xx + ox), yy, mychar,scalex,scaley,angle)
    draw_text_transformed((xx - ox), yy, mychar,scalex,scaley,angle)
    draw_text_transformed(xx, (yy + oy), mychar,scalex,scaley,angle)
    draw_text_transformed(xx, (yy - oy), mychar,scalex,scaley,angle)
    draw_set_alpha(((0.08 + (sin(timer / 14)) * 0.04) * specfade))
    draw_text_transformed((xx + ox), (yy + oy), mychar,scalex,scaley,angle)
    draw_text_transformed((xx - ox), (yy - oy), mychar,scalex,scaley,angle)
    draw_text_transformed((xx - ox), (yy + oy), mychar,scalex,scaley,angle)
    draw_text_transformed((xx + ox), (yy - oy), mychar,scalex,scaley,angle)
    draw_set_alpha(1)
}

_typer_drawsinglechar(x, y, image_alpha)