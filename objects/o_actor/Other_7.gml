if sprname == ""
	exit

var spr = struct_get(party_getdata(string_lower(name), "battle_sprites"), sprname)

if is_in_battle && is_array(spr) {
	if array_length(spr) > 2{
		image_speed = spr[2]
		image_index = 0
		sprite_index = enc_getparty_sprite(array_get_index(global.party_names, id.name), spr[1])
	}
	else if spr[1] {
		image_speed = 0
		image_index = sprite_get_number(sprite_index) - 1
	}
}