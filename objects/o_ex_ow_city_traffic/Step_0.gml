if !get_leader()._checkmove() 
    exit
if timer % rate == 0 && !inst.active || walk && timer % rate == 0 && inst.active {
	instance_create(o_ex_ow_city_traffic_car, x, y, depth, {
		myswitch: inst,
		spd,
		walk,
	})
}
if !inst.active {
	timer ++
	if walk
        timer = round(timer)
}
if walk && inst.active {
	timer += .25
}