if instance_exists(o_enc_box)
    timer ++
else
    exit

if timer % 30 == 0
    enc_enemy_add_spare(enemy_index, 20)

if o_enc_soul.i_frames > 0
    instance_destroy()