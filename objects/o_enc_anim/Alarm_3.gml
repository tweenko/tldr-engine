// set the party to do the idle sprites
for (var i = 0; i < array_length(global.party_names); ++i) {
	var obj = party_getobj(global.party_names[i])
	
    obj.sprite_index = enc_getparty_sprite(i, "idle")
    obj.image_speed = 1
    obj.image_index = 0
}

instance_create(o_enc,,,,{
	encounter_data: encounter_data, 
	savepos
})
if struct_exists(encounter_data, "bgm") && encounter_data.bgm != -1 {
	music_play(encounter_data.bgm, 1)
}

instance_destroy()