image_alpha = 0;

// split self into small panels if used as area
if image_xscale > 1 || image_yscale > 1 {
	for (var i = 0; i < image_xscale; i ++) {
		var xx = x + i*20;
		
		for (var j = 0; j < image_yscale; j ++) {
			var yy = y + j*20;
			if !place_meeting(xx, yy, o_ow_magicalglass)
				instance_create(o_ow_magicalglass, xx, yy, depth, {sprite_index: sprite_index});
		};
	};
	
	instance_destroy();
};