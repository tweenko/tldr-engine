if s_talking && image_speed == 0 {
	image_speed = 1
}
if image_index >= sprite_get_number(sprite_index)-1 {
	if !s_talking {
		image_speed = 0
		image_index = 0
	}
}