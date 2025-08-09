/// @description initialize
var count = 0
var iid = id
var t = type

with object_index{
	count ++
	if id != iid 
		type = (t == 0 ? 1 : 0)
}
buff = count