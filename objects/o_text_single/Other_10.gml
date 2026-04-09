/// @description draw
draw_set_font(font)

if god { // toby code
	shadow = false
	
	var xx = x + xoff
	var yy = y + yoff
	
	draw_set_alpha((1 * image_alpha))
    draw_set_alpha(((0.3 + (sin((timer / 14)) * 0.1)) * image_alpha))
    draw_text_transformed((xx + scalex), yy, symbol, scalex, scaley, angle)
    draw_text_transformed((xx - scalex), yy, symbol, scalex, scaley, angle)
    draw_text_transformed(xx, (yy + scaley), symbol, scalex, scaley, angle)
    draw_text_transformed(xx, (yy - scaley), symbol, scalex, scaley, angle)
    draw_set_alpha(((0.08 + (sin(timer / 14)) * 0.04) * image_alpha))
    draw_text_transformed((xx + scalex), (yy + scaley), symbol, scalex, scaley, angle)
    draw_text_transformed((xx - scalex), (yy - scaley), symbol, scalex, scaley, angle)
    draw_text_transformed((xx - scalex), (yy + scaley), symbol, scalex, scaley, angle)
    draw_text_transformed((xx + scalex), (yy - scaley), symbol, scalex, scaley, angle)
    draw_set_alpha(1)
}

_typer_drawsinglechar(x, y, image_alpha)