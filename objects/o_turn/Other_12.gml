/// @description box is created
var turn_counter = 0;
var shuffled = array_shuffle(pattern_pool);

for (var i = 0; i < array_length(o_enc.turn_objects); i ++) {
    with o_enc.turn_objects[i] {
        if other.object_index != object_index
            continue;
        
        if turn_counter >= array_length(shuffled) || !assign_unique_patterns
            pattern ??= array_shuffle(pattern_pool)[0];
        else
            pattern ??= shuffled[turn_counter];
        
        turn_counter ++;
    }
}