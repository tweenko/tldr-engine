if maker == noone 
    exit;

if maker.pulpit == true {
	if place_meeting(x, y, get_leader()) or get_leader().pf_final_ychange < 0
		collide = false;
	else
		collide = true;
}

var min_party_y = infinity;
for (var i = 0; i < party_length(true); ++i) {
	var inst = party_get_inst(global.party_names[i]);
	if inst.y < min_party_y 
        min_party_y = inst.y;
}

depth = -2000 - y - 1;
if collide == false and maker.collide_while_plat == false and maker.pulpit == false 
	depth = -2000;