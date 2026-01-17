if !enc_enemy_isfighting(target) 
	exit

var enemy_struct = ecaller.encounter_data.enemies[target]
var o = enemy_struct.actor_id

// change target if needed
if !enc_enemy_isfighting(target) || caller.enemy_hp[target] <= 0 {
    for (var i = 0; i < array_length(ecaller.encounter_data.enemies); i ++) {
        if enc_enemy_isfighting(i) && caller.enemy_hp[i] > 0 {
            target = i
            break
        }
    }
}

with o_enc
    party_state[other.index] = PARTY_STATE.IDLE
instance_create(o_eff_attackslash, o.x, o.s_get_middle_y(), DEPTH_ENCOUNTER.ACTORS - 500, {
	index, caller, dmg,
	sprite_index: party_getdata(global.party_names[index],"battle_sprites").attack_eff,
	ii,
	target,
	fatal: item_get_fatal(party_getdata(global.party_names[index], "weapon"))
})
caller.enemy_hp[target] -= dmg

if item_get_equipped(item_w_absorbax, global.party_names[index]) > 0
    party_heal(global.party_names[index], 2, o_enc)