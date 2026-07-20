global.menu_page = 0 // reset the menu page back to item when entering a new room
if !array_contains(asset_get_tags(room), "TLDR_Room_NoTracking") {
	global.last_room = room; // keep track of current room
}