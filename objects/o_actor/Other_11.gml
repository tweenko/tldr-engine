/// @description init record
var size = pos + 1
record = [
	array_create(size, x),
	array_create(size, y),
	array_create(size, dir),
	array_create(size, false),
	array_create(size, -1),
	array_create(size, false),
] // x, y, dir, running, moving, state, sliding