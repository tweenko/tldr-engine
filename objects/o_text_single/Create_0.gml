symbol = ""
font = loc_font("text")
scalex = 1
scaley = 1
angle = 0
gui = false

xcolor = c_white
solid_color = false
solid_colors = [
	c_white,
	c_black,
	merge_color(c_aqua, c_blue, 0.3)
]

shadow = true
shadowoff = [1,1]
shadowcol = -1

effect = 0
blur = 0
god = 0

xoff = 0
yoff = 0
timer = 0
caller = -1

sprite = -1
img_index = 0

_typer_drawsinglechar = function(xx, yy, opacity) {
	if sprite != -1 
		draw_sprite_ext(sprite, img_index, xx+xoff, yy+yoff, scalex, scaley, angle, c_white, opacity)
	else {
		if shadowcol != -1 {
			if shadow {
				draw_text_transformed_color(xx + xoff + shadowoff[0], yy + yoff + shadowoff[1],
					symbol, scalex, scaley, angle,
					shadowcol, shadowcol, shadowcol, shadowcol, opacity
				)
			}
		}
		else {
			if array_contains(solid_colors, xcolor) || solid_color {
				if shadow {
					draw_text_transformed_color(xx + xoff + shadowoff[0], yy + yoff + shadowoff[1],
						symbol, scalex, scaley, angle,
						c_dkgray, c_dkgray, c_navy, c_navy, opacity
					)
				}
			}
			else {
				if shadow {
					draw_text_transformed_color(xx + xoff + shadowoff[0], yy + yoff + shadowoff[1], 
						symbol, scalex, scaley, angle,
						xcolor, xcolor, xcolor, xcolor, opacity * .3
					)
				}
			}
		}
		if array_contains(solid_colors, xcolor) || solid_color
			draw_text_transformed_color(xx + xoff, yy + yoff,
				symbol, scalex, scaley, angle,
				xcolor, xcolor, xcolor, xcolor, opacity
			)
		else
			draw_text_transformed_color(xx + xoff, yy + yoff,
				symbol, scalex, scaley, angle,
				c_white, c_white, xcolor, xcolor, opacity
			)
	}
}