audio_play(snd_impact,,.7)

if epic 
	audio_play(snd_weaponpull,,.8)
else 
	audio_play(snd_weaponpull_fast,,.8)

// pull the weapons
for (var i = 0; i < array_length(global.party_names); ++i) {
	var obj = party_get_inst(global.party_names[i])
	var m = party_getdata(global.party_names[i], "s_battle_intro")
	
	if m != 0 {
		obj.sprite_index = enc_getparty_sprite(i, "attack")
		obj.image_speed = 1
		obj.image_index = 0
	}
	obj.trail = false
}

alarm[3] = 20