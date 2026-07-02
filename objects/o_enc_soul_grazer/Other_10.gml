/// @desc
if grazed_inst.color != BULLET_COLOR.SOLID
	exit;

if grazed_inst != grazed_previous {
    o_enc.tp += grazed_inst.graze;
    o_enc.tp = clamp(o_enc.tp, 0, 100);
    
    if grazed_inst.time_points > 0
        for (var i = 0; i < array_length(o_enc.turn_objects); i ++) {
            if instance_exists(o_enc.turn_objects[i]) && enc_enemy_is_fighting(i) 
                && o_enc.turn_objects[i].shorten_by_tension && is_real(o_enc.turn_objects[i].timer_end) 
                && o_enc.turn_objects[i].timer_end - o_enc.turn_objects[i].timer > 10
            {
                o_enc.turn_objects[i].timer_end -= grazed_inst.time_points;
                if item_get_equipped(item_a_silver_watch) 
                    o_enc.turn_objects[i].timer_end -= grazed_inst.time_points * .1;
            }
        }
    
    audio_play(snd_graze);
    
    image_index = 0;
    image_alpha = 1;
    graze_new_buffer = 5;
}
else {
    o_enc.tp += grazed_inst.graze/12;
    o_enc.tp = clamp(o_enc.tp, 0, 100);
    
    if grazed_inst.time_points > 0
        for (var i = 0; i < array_length(o_enc.turn_objects); i ++) {
            if instance_exists(o_enc.turn_objects[i]) && enc_enemy_is_fighting(i) 
                && o_enc.turn_objects[i].shorten_by_tension && is_real(o_enc.turn_objects[i].timer_end) 
                && o_enc.turn_objects[i].timer_end - o_enc.turn_objects[i].timer > 10
            {
                o_enc.turn_objects[i].timer_end -= grazed_inst.time_points/30;
            }
        }
}