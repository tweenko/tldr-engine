burst += 0.5
draw_sprite_ext(spr_soul_outline, 1, x, y, (0.25 + burst)/2, (0.25 + (burst / 2))/2, 0, c_white, (0.80000000000000004 - (burst / 6)))
draw_sprite_ext(spr_soul_outline, 0, x, y, (0.25 + (burst / 1.5))/2, (0.25 + (burst / 3))/2, 0, c_white, (1 - (burst / 6)))
draw_sprite_ext(spr_soul_outline, 0, x, y, (0.20000000000000001 + (burst / 2.5))/2, (0.20000000000000001 + (burst / 5))/2, 0, c_white, (1.2 - (burst / 6)))
if ((burst > 10))
    instance_destroy()