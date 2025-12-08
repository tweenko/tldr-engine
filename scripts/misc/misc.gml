function string_to_color(color_string){
	switch color_string{
		case "c_red":
		case "r":
			return c_red
		case "c_blue":
		case "b":
			return c_blue
		case "c_yellow":
		case "y":
			return c_yellow
		case "c_lime":
		case "g":
			return c_lime
		case "c_black":
			return c_black
		case "c_dkgray":
			return c_dkgray
		case "c_gray":
			return c_gray
		case "c_silver":
			return c_silver
        case "c_orange":
            return c_orange
		default:
			return c_white
	}
}
function color_to_string(color){
	var cc = merge_color(c_aqua, c_blue, 0.3)
    
	switch color {
		case c_red:
			return "c_red"
		case c_blue:
			return "c_blue"
		case c_green:
			return "c_green"
		case c_yellow:
			return "c_yellow"
		case c_lime:
			return "c_lime"
		case c_black:
			return "c_black"
		case cc:
			return "tired_aqua"
		default:
			return "c_white"
	}
}

///@desc draws the deltarune dialogue box
function ui_dialoguebox_create(xx, yy, width, height, world = global.world){
	var frame = (o_world.frames/10) % 8
	if world == WORLD_TYPE.DARK {
		draw_sprite_ext(spr_pixel, 0, xx + 12, yy + 12, width - 24, height - 24, 0, c_black, 1);
        
		draw_sprite_ext(spr_ui_dkbox_top, 0, xx + 16, yy, width - 32, 2, 0, c_white, 1)
		draw_sprite_ext(spr_ui_dkbox_top, 0, xx + 16, yy + height, width - 32, -2, 0, c_white, 1)
		draw_sprite_ext(spr_ui_dkbox_left, 0, xx, yy + 16, 2, height - 32, 0, c_white, 1)
		draw_sprite_ext(spr_ui_dkbox_left, 0, xx + width, yy + 16, -2, height - 32, 0, c_white, 1)
        
		draw_sprite_ext(spr_ui_dkbox_corner, frame, xx, yy, 2, 2, 0, c_white, 1)
		draw_sprite_ext(spr_ui_dkbox_corner, frame, xx + width, yy, -2, 2, 0, c_white, 1)
		draw_sprite_ext(spr_ui_dkbox_corner, frame, xx, yy + height, 2, -2, 0, c_white, 1)
		draw_sprite_ext(spr_ui_dkbox_corner, frame, xx + width, yy + height, -2, -2, 0, c_white, 1)
	}
	else {
		draw_sprite_ext(spr_pixel, 0, xx, yy, width, height, 0, c_white, 1);
		draw_sprite_ext(spr_pixel, 0, xx + 6, yy + 6, width - 12, height - 12, 0, c_black, 1);
	}
}

/// @ignore
/// @desc ripped from deltarune code. don't use this.
/// @param {real} alpha - The alpha transparency of the tiles (0 to 1).
function draw_sprite_tiled_area(sprite, subimg, xx, yy, x1, y1, x2, y2, xscale, yscale, blend, alpha) {
    var sw = sprite_get_width(sprite) * xscale;
    var sh = sprite_get_height(sprite) * yscale;

    // Normalize offsets
    var start_x = x1 - ((x1 - xx) % sw);
    var start_y = y1 - ((y1 - yy) % sh);

    for (var i = start_x; i < x2; i += sw) {
        for (var j = start_y; j < y2; j += sh) {
            var left = 0;
            var top = 0;
            var width = sw;
            var height = sh;

            // Clip left edge
            if (i < x1) {
                left = (x1 - i) / xscale;
                width -= (x1 - i);
            }
            if (j < y1) {
                top = (y1 - j) / yscale;
                height -= (y1 - j);
            }

            // Clip right edge
            if (i + width > x2) {
                width -= (i + width - x2);
            }
            if (j + height > y2) {
                height -= (j + height - y2);
            }

            draw_sprite_part_ext(sprite, subimg, left, top, width / xscale, height / yscale, i + left * xscale, j + top * yscale, xscale, yscale, blend, alpha);
        }
    }
}
/// @ignore
/// @desc ripped from deltarune code. don't use this.
function draw_sprite_part_parallax(sprite, image, xoff, yoff, alpha, xx = x, yy = y){
    var _mywidth = sprite_get_width(sprite)
    var _myheight = sprite_get_height(sprite)
	
    var _xoffset = xoff%_mywidth
    var _yoffset = yoff%_myheight
	
    if _xoffset<0 _xoffset+=_mywidth
    if _yoffset<0 _yoffset+=_myheight
	
    if _xoffset==0 && _yoffset==0
        draw_sprite_ext(sprite, image, xx, yy, 1, 1, 0, image_blend, alpha)
    else{
        draw_sprite_part_ext(sprite, image, 0, 0, (_mywidth - _xoffset), (_myheight - _yoffset), (xx + _xoffset), (yy + _yoffset), 1,1, image_blend, alpha)
        draw_sprite_part_ext(sprite, image, (_mywidth - _xoffset), (_myheight - _yoffset), _xoffset, _yoffset, xx, yy, 1, 1, image_blend, alpha)
        draw_sprite_part_ext(sprite, image, 0, (_myheight - _yoffset), (_mywidth - _xoffset), _yoffset, (xx + _xoffset), yy,1,1, image_blend, alpha)
        draw_sprite_part_ext(sprite, image, (_mywidth - _xoffset), 0, _xoffset, (_myheight - _yoffset), xx, (yy + _yoffset), 1,1, image_blend, alpha)
    }
}
/// @ignore
/// @desc ripped from deltarune code. don't use this.
function draw_sprite_part_parallax_scale(sprite, image, xoff, yoff, alpha, scale, xx = x,yy = y, xmax = -1, ymax = -1){
    var _mywidth = sprite_get_width(sprite)
    var _myheight = sprite_get_height(sprite)
	
    var _xoffset = xoff%_mywidth
    var _yoffset = yoff%_myheight
	
    if _xoffset<0 _xoffset+=_mywidth
    if _yoffset<0 _yoffset+=_myheight
	
    var _xmax = (xmax==-1 ? _mywidth * scale : xmax)
    var _ymax = (ymax==-1 ? _myheight * scale : ymax)
	
    if _xoffset==0 && _yoffset==0
        draw_sprite_ext(sprite, image, xx, yy, 1, 1, 0, image_blend, alpha)
    else{
        draw_sprite_part_ext(sprite, image, 0, 0, (_xmax - _xoffset), (_ymax - _yoffset), (xx + _xoffset * scale), (yy + _yoffset * scale), scale, scale, image_blend, alpha)
        draw_sprite_part_ext(sprite, image, (_mywidth - _xoffset), (_myheight - _yoffset), min(_xmax, _xoffset), min(_ymax, _yoffset), xx, yy, scale, scale, image_blend, alpha)
        draw_sprite_part_ext(sprite, image, 0, (_ymax - _yoffset), min(_xmax, (_xmax - _xoffset)), min(_ymax, _yoffset), (xx + _xoffset * scale), yy, scale, scale, image_blend, alpha)
        draw_sprite_part_ext(sprite, image, (_xmax - _xoffset), 0, min(_xmax, _xoffset), min(_ymax, (_ymax - _yoffset)), xx, (yy + _yoffset * scale), scale, scale, image_blend, alpha)
    }
}

function convert_leader_equipment() {
    var __weapon = party_getdata(global.party_names[0], "weapon")
    if !is_undefined(__weapon)
        global.lw_weapon = __weapon.lw_counterpart
    
    var __armor1 = party_getdata(global.party_names[0], "armor1")
    if !is_undefined(__armor1)
        global.lw_armor = __armor1.lw_counterpart
    var __armor2 = party_getdata(global.party_names[0], "armor2")
    if !is_undefined(__armor2) && !is_undefined(__armor2.lw_counterpart)
        global.lw_armor = __armor2.lw_counterpart
    
    if !is_undefined(global.lw_weapon) && is_callable(global.lw_weapon)
        global.lw_weapon = new global.lw_weapon()
    if !is_undefined(global.lw_armor) && is_callable(global.lw_armor)
        global.lw_armor = new global.lw_armor()
}

function world_switch(world) {
    var wprevious = global.world
    global.world = world
    
    if wprevious != global.world
        convert_leader_equipment()
}

/// @desc a function that creates a text typer and returns its instance
/// @arg {string|array<string>} text the text that the instance will print out. can be both an array that will be split by {p}{c} and a simple string
/// @arg {real} x the x position of the to be created text typer instance
/// @arg {real} y the y position of the to be created text typer instance
/// @arg {real} [depth] the depth of the to be created text typer instance
/// @arg {string} [prefix] the string that will be added to the beginning of text
/// @arg {string} [postfix] the string that will be added to the tail of text (before {stop})
/// @arg {struct} [var_struct] the variable struct of the text typer. is a post variable struct
/// @arg {bool} [end_with_stop] true by default. whether the function should add "{stop}" after the string. highly recommended, since the abscence of stop can lead to softlocks
function text_typer_create(text, _xx, _yy, _depth = 0, prefix = "", postfix = "", var_struct = {}, end_with_stop = true) {
    var inst = instance_create(
        o_text_typer, 
        _xx, _yy, _depth, 
        var_struct
    )
    inst.text = prefix + dialogue_array_to_string(text) + postfix + (end_with_stop ? "{stop}" : "")
    
    return inst
}

function draw_text_scale(_string = "", _x = 0, _y = 0, _scale = 2, _col = c_white, _alp = 1) {
	draw_text_transformed_color(_x, _y, _string, _scale, _scale, 0, _col, _col, _col, _col, _alp)
}

///@desc	text_transformed but with a shadow
///@arg	{real}		x
///@arg	{real}		y
///@arg	{string}	str
///@arg	{real}		xscale
///@arg	{real}		yscale
///@arg	{real}		angle
///@arg	{real}		shd_space
///@arg	{real}		shd_colour
function draw_text_transformed_shadow(xx,yy,str,xscale,yscale,angle,shd_space,shd_col){
	var svd = draw_get_color()
	
	draw_set_color(shd_col)
	draw_text_transformed(xx+shd_space,yy+shd_space,str,xscale,yscale,angle)
	draw_set_color(svd)
	
	draw_text_transformed(xx,yy,str,xscale,yscale,angle)
}

function draw_pixel(x, y, w, h, col = draw_get_color(), alp = draw_get_alpha(), rot = 0) {
	draw_sprite_ext(spr_pixel, 0, x, y, w, h, rot, col, alp);
}
function draw_pixel_center(x, y, w, h, col = draw_get_color(), alp = draw_get_alpha(), rot = 0){
	draw_sprite_ext(spr_pixelfour, 0, x, y, w/4, h/4, rot, col, alp);
}