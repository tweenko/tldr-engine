event_inherited()

if image_alpha < 1 {
    image_alpha += .1
    image_xscale += .04
}
if spd < 1 && !_underaura
    spd += .1

speed = spd * (1 + sine(10, .3, timer))

if instance_exists(homing_target) {
    var target_dir = point_direction(x, y, homing_target.x, homing_target.y) + 180
    var diff = angle_difference(direction, target_dir)
    
    if abs(diff) > 2
        direction += sign(diff) * 4 // rotate toward target
    else
        direction = target_dir // snap if close enough
}

_underaura = false
timer ++ 