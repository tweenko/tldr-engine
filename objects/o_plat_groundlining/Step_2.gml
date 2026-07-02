if maker == noone 
    exit;

if maker.pulpit == true {
	if place_meeting(x, y, get_leader()) or get_leader().pf_jump_smoothed_final_y_change < 0
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
if y + 1 < min_party_y or collide == false and (maker.collide_while_plat == false) 
    depth = DEPTH_PLATFORMER.BACK
else 
    depth = depth_start;