timer++;
var target = get_leader();


for (var i = trail_max - 1; i > 0; i--) {
    trail_x[i] = trail_x[i-1];
    trail_y[i] = trail_y[i-1];
}
trail_x[0] = x;
trail_y[0] = y;

if (mode == "instant") {

} else {
    if (timer < 25) {
        speed = 0; 
        if (instance_exists(target)) {
            if (tracking_type == "x") x = lerp(x, target.x, 0.4);
            else if (tracking_type == "y") y = lerp(y, target.y, 0.4);
            else if (tracking_type == "point") direction = point_direction(x, y, target.x, target.y);
        }
    } else {
        if (timer == 25) audio_play(snd_flash, 0, 1, 1.2); 
        speed += 0.6; 
    }
}

image_angle = direction + 90;

if (timer > 1200) {
    image_alpha -= 0.1;
    if (image_alpha <= 0) instance_destroy();
}