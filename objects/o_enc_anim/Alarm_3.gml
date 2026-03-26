// set the party to do the idle sprites
for (var i = 0; i < party_length(); ++i) {
	var obj = party_get_inst(global.party_names[i])
	
    obj.sprite_index = enc_getparty_sprite(global.party_names[i], "idle")
    obj.image_speed = 1
    obj.image_index = 0
}

var inst = instance_create(o_enc,,,,{
	encounter_data: encounter_data, 
	save_pos,
    save_follow,
})

// do the initial flavor text
var flavor_text = encounter_data.flavor
if is_callable(flavor_text)
    flavor_text = flavor_text()

inst.flavor = flavor_text

var __vs = encounter_data.enc_var_struct
var __names = struct_get_names(__vs)
for (var i = 0; i < array_length(__names); i ++) {
    variable_instance_set(inst, __names[i], struct_get(__vs, __names[i]))
}

if struct_exists(encounter_data, "bgm") && audio_exists(encounter_data.bgm) {
	music_play(encounter_data.bgm, 1, true, encounter_data.bgm_gain, encounter_data.bgm_pitch)
}

instance_destroy()