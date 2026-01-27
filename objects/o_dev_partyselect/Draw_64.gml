var w = 260
var h = 100

draw_sprite_ext(spr_pixel, 0, 0, 0, 640, 480, 0, c_black, .5)
ui_dialoguebox_create(320 - w/2, 240 - h/2, w, h)

for (var i = 0; i < maxparty; ++i) {
	if abs(i-selection) > 1
		continue
	
	var name = struct_get_names(global.party)[i]
	var xx = 320-25 + i*54 - xoff*54
	var yy = 240-20
	
	if i == selection {
		gpu_set_fog(true, (array_contains(global.party_names, name) ? party_getdata(name, "color") : c_white), 0, 0)
		for (var j = 0; j < 360; j += 90) {
			var xdelta = lengthdir_x(2, j)
			var ydelta = lengthdir_y(2, j)
			draw_sprite_ext(party_geticon_ow(name), 0, 
				xx + xdelta,yy + ydelta,
				2, 2,
				0, c_white, (i==selection ? 1 : .3)
			)
		}
		gpu_set_fog(false, c_white, 0, 0)
	}
	
    if !array_contains(global.party_names, name) 
		shader_set(shd_greyscale)
	draw_sprite_ext(party_geticon_ow(name), 0,
		xx, yy,
		2, 2,
		0, (array_contains(global.party_names, name) ? c_white : c_gray), (i==selection ? 1 : .3)
	)
	if !array_contains(global.party_names, name) 
		shader_reset()
}

var name = struct_get_names(global.party)[selection]
if selection > 0 
	draw_sprite_ext(spr_ui_arrow_left, 0, 320 - 90 + round(sine(6, 2)), 240, 1, 1, 0, c_white, 1)
if selection < maxparty - 1 
	draw_sprite_ext(spr_ui_arrow_right, 0, 320 + 90 + round(sine(6, -2)), 240, 1, 1, 0, c_white, 1)