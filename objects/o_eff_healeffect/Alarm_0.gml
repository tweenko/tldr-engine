var xx = random_range(-target.sprite_width/2, target.sprite_width/2)
var yy  =random(target.myheight)

instance_create(o_eff_magicstar, target.x + xx, target.y - yy, target.depth-2)

if count < 5 
	alarm[0] = 1
else instance_destroy()

count++