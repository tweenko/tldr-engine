/// @desc load localized assets

var __charset = loc("font_name")[1]
var __spr = asset_get_index(loc("font_name")[0])

global.font_name = [undefined, undefined, undefined]
global.font_name[2] = font_add_sprite_ext(__spr, __charset, true, -1);
global.font_name[1] = font_add_sprite_ext(__spr, __charset, true, 0);
global.font_name[0] = font_add_sprite_ext(__spr, __charset, true, 1);

if instance_exists(o_ui_quit)
    o_ui_quit.sprite_index = asset_get_index(loc("menu_misc_quit"))