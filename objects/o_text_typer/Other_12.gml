/// @description clear

disp_chars = 0
chars = 0
xoff = 0
yoff = 0

for (var i = 0; i < array_length(mychars); ++i) {
	instance_destroy(mychars[i])
}
for (var i = 0; i < array_length(mini_faces); ++i) {
	instance_destroy(mini_faces[i])
}

mychars = []
mini_faces = []
superskipping_buffer = 1

init = true

current_box ++