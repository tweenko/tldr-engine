graze_buffer = 0;
grazed_inst = noone;
can_graze = false;

image_alpha = 0;
image_speed = 0;
image_xscale = 0.5;
image_yscale = 0.5;

var __increase = 1
__increase += .2 * item_get_equipped(item_a_pink_ribbon)
__increase += .25 * item_get_equipped(item_a_twin_ribbon)

image_xscale = clamp(image_xscale * __increase, image_xscale, image_xscale * 2.5)
image_yscale = image_xscale