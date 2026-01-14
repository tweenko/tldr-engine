/// @description box is created
o_enc.mybox.sprite_index = spr_ex_box_complex
o_enc.mybox.mask_index = spr_ex_box_complex_mask
o_enc.mybox.sprite_back = spr_ex_box_complex_back_2x

with o_enc.mybox {
    sprite_w = sprite_get_width(sprite_index)
    sprite_h = sprite_get_height(sprite_index)
}