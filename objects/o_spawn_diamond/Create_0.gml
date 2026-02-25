event_inherited()

image_xscale = 2
image_yscale = 2
image_angle = direction + 90; 
mode = "windup";
tracking_type = "";
speed = 2
timer = 0

element = "dark_star"
dmg = 20

image_xscale = 0
collide = false;


if (sprite_index == -1) sprite_index = spr_ex_e_dentos_diamond; 
depth_override = -16000; 

trail_max = 6; 
for (var i = 0; i < trail_max; i++) {
    trail_x[i] = x;
    trail_y[i] = y;
}