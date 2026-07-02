if maker==noone exit
depth = DEPTH_PLATFORMER.LINING+maker.wall_distance
var min_party_y = 999999
for (var i = 0; i < party_length(true); ++i) {
	var inst = party_get_inst(global.party_names[i])
	if inst.y < min_party_y min_party_y = inst.y
}
if y+1<min_party_y or (collide==false and (maker.collide_while_plat==false)) {depth = DEPTH_PLATFORMER.BACK}
var blend = merge_color(maker.image_blend, maker.blend_while_plat, global.platforming_perspective)
image_xscale = (sprite_get_width(maker.sprite_index)*maker.image_xscale)/sprite_get_width(sprite_index)
x = maker.x
y = maker.y
if sprite_index!=spr_plat_default_lining_mask draw_sprite_ext(sprite_index, subimg_auto_sprite(sprite_index), maker.x, maker.y, image_xscale, 1, 0, blend, maker.image_alpha*global.platforming_perspective)
