event_inherited()

return_marker = 0
interaction_code = function() {
    shop_start(new ex_shop_color_cafe(), room, return_marker)
}
s_drawer = function(_sprite, _index, _xx, _yy, _xscale, _yscale, _angle, _blend, _alpha) {
    draw_sprite_ext(spr_ex_ow_npc_swatch, 0, _xx, _yy - 20, _xscale, _yscale, _angle, _blend, _alpha)
    draw_sprite_ext(spr_ex_ow_swatch_stand, 0, x, y, 1, 1, 0, c_white, 1)
}