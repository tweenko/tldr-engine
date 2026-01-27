if instance_exists(o_enc) 
	exit

var cyclethrough = [o_actor] // add instances that are non-actors here to be reflected

for (var j = 0; j < array_length(cyclethrough); ++j) {
    var insts = []
	for (var i = 0; i < instance_number(cyclethrough[j]); i++) {
	    var inst = instance_find(cyclethrough[j], i)
		if inst.can_reflect
			array_push(insts, [inst, inst.depth])
	}

	insts = array_sort_ext(insts, function(a, b) {
	    if a[1] == b[1] {
			return 0
		}
		else if a[1] < b[1] {
			return 1
		}
		else return -1
	})

	for (var i = 0; i < array_length(insts); i++) {
	    var inst = insts[i][0]
	    if distance_to_object(inst) < 20{
	        with inst 
				reflection_code()
	    }
	}
}