///@desc progress order
var a = array_sort_ext(caller.pattern, false)

caller.order ++
if caller.order < a[0] { // continue the order until the next stick is found
	while !array_contains(caller.pattern, caller.order) {
		caller.order++
	}
}