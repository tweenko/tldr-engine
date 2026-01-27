// make the dodge effects fade in and fade out
if !dodge_override {
	if dodge_mode
		dodge_alpha = lerp(dodge_alpha, 1, .2)
	else 
		dodge_alpha = lerp(dodge_alpha, 0, .15)
    
	dodge_alpha = clamp(dodge_alpha, 0, 1)
}