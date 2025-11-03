if !instance_exists(o_dodge_controller)
    exit

x = get_leader().x
y = get_leader().y - get_leader().sprite_height/2 + 4

image_alpha = o_dodge_controller.dodge_alpha
if image_alpha == 0 
	instance_destroy()

if place_meeting(x, y, o_dodge_bullet) && i_frames == 0 {
	with instance_place(x, y, o_dodge_bullet)
		event_user(1)
}
if i_frames > 0 {
	i_frames --;
	image_speed = .25;
} 
else {
	image_speed = 0;
	image_index = 0;
	i_frames = 0;
}