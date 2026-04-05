/// @desc load localized assets

var __charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890/"
var __spr = spr_ui_partyname_font

if is_array(loc("font_name")) {
    __charset = loc("font_name")[1]
    __spr = asset_get_index(loc("font_name")[0])
}

global.font_name = [undefined, undefined, undefined]
global.font_name[2] = font_add_sprite_ext(__spr, __charset, true, -1);
global.font_name[1] = font_add_sprite_ext(__spr, __charset, true, 0);
global.font_name[0] = font_add_sprite_ext(__spr, __charset, true, 1);

if instance_exists(o_ui_quit)
    o_ui_quit.sprite_index = asset_get_index(loc("menu_misc_quit"))