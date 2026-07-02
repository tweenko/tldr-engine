if speed < 3
    friction = 0.1;
if speed < 1
    fallspeed = increment_towards(fallspeed, 1, 0.05);

y += fallspeed/2;
x += (sin(siner / 15) * (fallspeed / 4));

siner ++;
image_angle = (-cos(siner / 15) * 30) + spin_offset;

if spinner < 1 {
    spinner += 0.1;
    spin_offset = anime_curve_lerp(spin_start, 0, spinner, anime_curve.quad_out);
}

if fallspeed == 1
    lifetime --;

if lifetime <= 0 {
    image_alpha -= 0.1;
    
    if (image_alpha <= 0)
        instance_destroy();
}