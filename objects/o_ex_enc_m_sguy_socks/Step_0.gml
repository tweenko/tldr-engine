if shake > 0 shake -- 

if hits >= maxhits && collide {
	collide = false
	gravity = .3
	hspeed = 3
	vspeed = -4
}
if !collide {
	image_angle -= 2
}