/// @desc
if !instance_exists(get_leader())
	exit

var kris = (get_leader())
var char_y = kris.y - (sprite_get_height(kris.sprite_index)/2);

if transition_mode == 0 {
	instance_create(o_eff_soulappear, kris.x, char_y, depth-10)
	var xx = o_enc.mybox.x;
	var yy = o_enc.mybox.y;
	
	do_animate(kris.x, xx, 8, "linear", id, "x")
	do_animate(char_y, yy, 8, "linear", id, "y")
	do_animate(0, 1, 4, "linear", id, "image_alpha")
} 
else {
	do_animate(x, kris.x, 8, "linear", id, "x")
	do_animate(y, char_y, 8, "linear", id, "y")
}

is_transitioning = true;

alarm[1] = 8;