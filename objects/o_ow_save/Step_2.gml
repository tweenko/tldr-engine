event_inherited()

if !instance_exists(inst) && started {
	started = false
	
	audio_play(snd_heal) 
	for (var i = 0; i < array_length(global.party_names); ++i) {
		party_setdata(global.party_names[i], "hp", party_getdata(global.party_names[i], "max_hp"))
	}
	
	instance_create(o_ui_save)
}