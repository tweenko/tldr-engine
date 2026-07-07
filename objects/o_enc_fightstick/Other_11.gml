/// @description process attack
if enc_enemy_count() == 0 
	exit

while !enc_enemy_is_fighting(target) {
	target ++
	if target > array_length(ecaller.encounter_data.enemies) - 1 {
		target = 0
	}
}

var o = party_get_inst(global.party_names[index])
var dist = floor(abs(x - 87) - 3)

// calculate accuracy
var accuracy = 0
if perfect 
	accuracy = 150
else if dist < 7 
	accuracy = 120
else if dist < 14 
	accuracy = 110
else if dist >= 14
	accuracy = round(max(0, 100 - (dist / 7 * 2)))

var member_weapon = party_getdata(global.party_names[index], "weapon")
var weapon_element = undefined
if is_struct(member_weapon) && is_struct(member_weapon.weapon_element)
    weapon_element = member_weapon.weapon_element

dmg = (party_getdata(global.party_names[index], "attack") * accuracy) / 20
dmg -= 3 * ecaller.encounter_data.enemies[target].defense
dmg = max(1, dmg)

// add the element multiplier
var weE = weapon_element.element
var eeE = ecaller.encounter_data.enemies[target].element
if is_array(weE) and is_array(eeE) and function(){for (var i=0; i<array_length(weE)-1; i+=1){for (var j=0; j<array_length(eeE)-1; j+=1){if weE[i]==eeE[j] return true else return false}}}
or is_array(weE) and !is_array(eeE) and array_contains(weE, eeE) 
or !is_array(weE) and is_array(eeE) and array_contains(eeE, weE) 
or weE == eeE
    dmg *= weapon_element.multiplier;

dmg = round(dmg)

if ecaller.tp_constrict
    ecaller.tp += round(lerp(0, 2, accuracy/150))
else
    ecaller.tp += max(0, round(accuracy / 10 / 2.5))

if perfect {
	repeat(3) {
		instance_create(o_eff_criticalsparkle, 
			o.x + 10 + random(20), 
			o.s_get_middle_y() - random(6), 
			o.depth - 10
		)
	}
}

o.sprite_index = enc_getparty_sprite(global.party_names[index], "attack")
o.image_index = 0
o.image_speed = 1