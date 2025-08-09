image_alpha -= decay_speed

if image_alpha == 0
	instance_destroy(self)