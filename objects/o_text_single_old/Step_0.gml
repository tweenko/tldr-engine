timer ++

if effect == "wave" {
    var amp = effect_arguments[0];
    var freq = effect_arguments[1];
    
	yoff = sine(freq, amp, timer);
}
else if effect == "shake" {
    var pow = effect_arguments[0];
    
	xoff = random_range(-pow, pow);
	yoff = random_range(-pow, pow);
}
else if effect == "light_shake" {
    var pow = .51;
    
	xoff = round(random_range(-pow, pow));
	yoff = round(random_range(-pow, pow));
}

if img_spd != 0
    img_index += img_spd