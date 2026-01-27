timer ++
if timer < 5 {
	repeat(2) 
		instance_create(o_eff_sparestar, x + random(w), y + random(h), depth)
}
else {
	instance_destroy()
}