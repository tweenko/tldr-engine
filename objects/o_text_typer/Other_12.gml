/// @description clear
disp_chars = 0
chars = 0
xoff = 0
yoff = 0

for (var i = 0; i < array_length(mychars); ++i) {
	instance_destroy(mychars[i])
}

mychars = []
init = true

current_box ++