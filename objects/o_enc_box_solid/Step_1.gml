// calculate change
move_dx = x - prev_x
move_dy = y - prev_y
move_da = angle_difference(image_angle, prev_angle)
move_w = image_xscale * sprite_get_width(sprite_index) - prev_width
move_h = image_yscale * sprite_get_height(sprite_index) - prev_height

prev_x = x
prev_y = y
prev_angle = image_angle
prev_width = image_xscale * sprite_get_width(sprite_index)
prev_height = image_yscale * sprite_get_height(sprite_index)