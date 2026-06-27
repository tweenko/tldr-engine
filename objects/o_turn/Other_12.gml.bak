/// @description box is created
var shuffled = array_shuffle(pattern_pool)
for (var i = 0; i < array_length(o_enc.turn_objects); i ++) {
    with o_enc.turn_objects[i] {
        if other.object_index != object_index
            continue
        
        if i >= array_length(shuffled)
            pattern ??= array_shuffle(pattern_pool)[0]
        else
            pattern ??= shuffled[i]
    }
}