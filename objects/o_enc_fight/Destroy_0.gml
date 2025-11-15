caller.waiting = false
for (var i = 0; i < array_length(fighting); ++i) {
	var o = party_get_inst(fighting[i])
	o.sprite_index = enc_getparty_sprite(array_get_index(global.party_names,fighting[i]), "idle")
	o.image_index = 0
	o.image_speed = 1
    
    o_enc.char_state[party_getpos(fighting[i])] = CHAR_STATE.IDLE
}