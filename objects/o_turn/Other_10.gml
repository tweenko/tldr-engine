/// @description initialize
var count = 0
var iid = id

with object_index {
	count ++
	
	if id != iid // to avoid creating the same turn objects over and over. instead buff the attack.
		instance_destroy()
}

buff = count - 1 // remove yourself