if destroy
	image_alpha = clamp(image_alpha - 0.1, 0, 1);
else if alphain
	image_alpha = clamp(image_alpha + 0.1, 0, 1);

if destroy and image_alpha == 0
	instance_destroy();