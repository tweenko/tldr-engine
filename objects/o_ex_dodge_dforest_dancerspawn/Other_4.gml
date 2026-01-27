/// @description spawn dancers
for (var i = 0; i < array_length(pattern); ++i) {
	if !pattern[i] 
        continue
	var adv = i/array_length(pattern)
    var inst = instance_create(o_ex_dodge_dforest_dancer, 0, 0, depth, {path})
	
    with inst {
		path_start(path, 3, path_action_restart, true);
		path_position = adv
	}
}