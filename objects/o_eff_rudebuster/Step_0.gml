timer ++

var dir = point_direction(x, y, target_x, target_y);
direction += (angle_difference(dir, direction) / 4);
image_angle = direction

instance_create(o_eff_rudebuster_trail, x, y, depth + 10, {
    sprite_index, image_index, image_speed, image_angle
})

if InputPressed(INPUT_VERB.SELECT) && !upgraded {
    if timer > 9
        dmg += 30
    else if timer > 8
        dmg += 28
    else if timer > 6
        dmg += 20
    else if timer > 5
        dmg += 13
    else if timer > 4
        dmg += 11
    else if timer > 3
        dmg += 10
    else if timer > 2
        dmg += 7
    
    upgraded = true
}

if point_distance(x, y, target_x, target_y) < 20 {
    x = target_x
    y = target_y
    
    animate(6, 0, 15, "linear", enemy_o, "shake")
    enc_hurt_enemy(slot, dmg, party_getpos(user))
    audio_play(snd_rudebuster_hit)
    
    for (var i = 45; i < 360; i += 90) {
        instance_create(o_eff_rudebuster_exp, x, y, depth, {
            speed: 4.5,
            image_angle: i,
        })
        instance_create(o_eff_rudebuster_exp, x, y, depth, {
            speed: 4.75,
            image_angle: i,
        })
    }
    
    instance_destroy()
}