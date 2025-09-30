if !enc_enemy_isfighting(target) 
	exit

var o = ecaller.encounter_data.enemies[target].actor_id

instance_create(o_eff_attackslash, o.x, o.y - o.myheight/2, DEPTH_ENCOUNTER.ACTORS - 500, {
	index, caller, dmg,
	sprite_index: party_getdata(global.party_names[index],"battle_sprites").attack_eff,
	ii,
	target,
	fatal: item_get_fatal(party_getdata(global.party_names[index], "weapon"))
})

if item_get_equipped(item_w_absorbax, global.party_names[index]) > 0
    party_heal(global.party_names[index], 2, o_enc)