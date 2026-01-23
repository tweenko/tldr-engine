if !instance_exists(o_enc_soul)
    exit
if instance_exists(o_enc_box)
    timer ++
else
    exit

if timer == 1 {
    var o = o_enc.encounter_data.enemies[enemy_index].actor_id
    inst_hpchange = instance_create(o_text_hpchange, o.x, o.s_get_middle_y(), o.depth, {draw: "+5%", mode: TEXT_HPCHANGE_MODE.PERCENTAGE})
}
if timer % 2 == 0 {
    mercy_added = clamp((timer div 2) + 5, 0, 100)
    inst_hpchange.draw = $"+{mercy_added}%"
    inst_hpchange.alarm[1] = 20
    
    if mercy_added >= 0 {
        audio_play(snd_mercyadd)
        instance_destroy()
    }
}

if o_enc_soul.i_frames > 0
    instance_destroy()