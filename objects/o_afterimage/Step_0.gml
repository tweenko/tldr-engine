image_alpha -= decay_speed

image_xscale += scale_mod;
image_yscale += scale_mod;

if image_alpha == 0
	instance_destroy(self)