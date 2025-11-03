if !inited
	exit

var scale = 1
var xoff = 5
if (side == 1)
    draw_sprite_ext(spr[1], 0, x+xoff, y, 1, scale, 0, c_white, 1)
if (side == -1)
    draw_sprite_ext(spr[1], 0, x-xoff, y, -1, scale, 0, c_white, 1)

draw_set_color(c_white)
draw_sprite_stretched_ext(spr[0], 0, textx-10, texty-10, balloonwidth+10, balloonheight+10, c_white, 1)