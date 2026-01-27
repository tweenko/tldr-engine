var instance = noone
var tgt = myswitch_id

with(o_ex_ow_city_traffic_switch){
	if switch_id == tgt {
		instance = id
		break
	}
}

inst = instance

//prepopulate
for (var i = 0; i < 150; i+=rate) {
	instance_create(o_ex_ow_city_traffic_car, x, y + i*spd, depth, {
		myswitch: inst,
		spd,
	})
}