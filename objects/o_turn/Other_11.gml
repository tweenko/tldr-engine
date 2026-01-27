/// @description turn starts
turn_started = true

var shuffled = array_shuffle(pattern_pool)
for (var i = 0; i < array_length(o_enc.turn_objects); i ++) {
    with o_enc.turn_objects[i] {
        if i >= array_length(shuffled)
            pattern = array_shuffle(pattern_pool)[0]
        else
            pattern = shuffled[i]
    }
}