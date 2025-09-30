event_inherited()

if timer == 0
    exit

if timer % 25 == 0 {
    instance_create(o_enc_bullet_dark, 
        o_enc_box.x + random_range(40, 70)*choose(-1, 1), 
        o_enc_box.y + random_range(40, 70)*choose(-1, 1), DEPTH_ENCOUNTER.BULLETS_OUTSIDE, {
            homing_target: o_enc_soul
    })
}

var end_turn = true
for (var i = 0; i < array_length(o_enc.turn_objects); i ++) {
    if instance_exists(o_enc.turn_objects[i]) && o_enc.turn_objects[i] != id {
        end_turn = false
        break
    }
}

if end_turn
    instance_destroy()