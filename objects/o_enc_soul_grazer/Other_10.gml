/// @desc
if grazed_inst.color != 0
	exit

o_enc.tp += grazed_inst.graze
o_enc.tp = clamp(o_enc.tp, 0, 100)

for (var i = 0; i < array_length(o_enc.turn_objects); i ++) {
    if instance_exists(o_enc.turn_objects[i]) && enc_enemy_isfighting(i) && o_enc.turn_objects[i].shorten_by_tension && is_real(o_enc.turn_objects[i].timer_end) {
        o_enc.turn_objects[i].timer_end -= 2
        
        if item_get_equipped(item_a_silver_watch) 
            o_enc.turn_objects[i].timer_end -= .1
    }
}

audio_play(snd_graze)

image_index = 0;
image_alpha = 1