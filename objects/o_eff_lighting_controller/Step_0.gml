// make the lighting fade in and fade out
if !lighting_override {
	if under_lighting
		lighting_alpha += 1/30
	else 
		lighting_alpha -= 1/30
    
	lighting_alpha = clamp(lighting_alpha, 0, 1)
}