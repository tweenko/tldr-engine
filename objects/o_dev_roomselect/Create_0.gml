selection = 0
selected_room = 0

inaccessible = [room_init]

global.console = true

depth = DEPTH_UI.CONSOLE

room_list = []

var rm = room_first
while room_exists(rm) {
    array_push(room_list, rm)
    rm = room_next(rm)
}