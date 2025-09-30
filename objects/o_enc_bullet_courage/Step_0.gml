image_xscale = lerp(image_xscale, tp/8, .1)
image_yscale = image_xscale

image_blend = merge_color(c_white, c_yellow, min(timer/10, 1))

if instance_exists(o_enc_soul) {
    var target_dir = point_direction(x, y, o_enc_soul.x, o_enc_soul.y)
    var diff = angle_difference(direction, target_dir)
    
    if abs(diff) > 2
        direction += sign(diff) * 10 // rotate 2 degrees toward target
    else
        direction = target_dir // snap if close enough
}

if timer > 5 && speed > -2 {
    speed -= .1
    friction = 0
}

timer ++