event_inherited()

if timer == 0
    exit

var __buffed_period = clamp(25 - (5 * buff), 15, 25)
if timer % __buffed_period == 0 {
    instance_create(o_enc_bullet_dark, 
        o_enc_box.x + random_range(40, 70)*choose(-1, 1), 
        o_enc_box.y + random_range(40, 70)*choose(-1, 1), DEPTH_ENCOUNTER.BULLETS_OUTSIDE, {
            homing_target: o_enc_soul
    })
}

__support_destroy_check()