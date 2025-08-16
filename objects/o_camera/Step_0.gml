if !instance_exists(target) {
	camera_set_view_target(camera, noone);
	camera_set_view_pos(camera, x, y);
}
else {
	camera_set_view_target(camera, target);
	camera_set_view_border(camera, width/scale_x / 2, height/scale_y / 2);
	x = camera_get_view_x(camera);
	y = camera_get_view_y(camera);
}

camera_set_view_size(camera, width/scale_x, height/scale_y);
camera_set_view_angle(camera, angle);