caller.waiting_internal = false
for (var i = 0; i < array_length(fighting); ++i) {
	with caller {
        party_state[party_get_index(other.fighting[i])] = PARTY_STATE.IDLE
        enc_party_set_battle_sprite(other.fighting[i], "idle")
    }
}