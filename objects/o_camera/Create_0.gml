width = 320
height = 240
scale_x = 1
scale_y = 1
angle = 0
target = noone

follow_x = true
follow_y = true
offset_x = 0
offset_y = 0

animation_x = undefined
animation_y = undefined
confined_on_x = true
confined_on_y = true

event_user(0)

camera = camera_create_view(x, y,
	width / scale_x, height / scale_y,
	angle, target, -1, -1,
	width/scale_x / 2, height/scale_y / 2
)