if keyboard_check(vk_tab) {
	active = true
	if !global.console 
		global.console = true
}
else {
	active = false
	if global.console 
		global.console = false
}

if active {
	var curkey = chr(keyboard_key)
	if keyboard_key == vk_tab
		curkey = ""
		
	if struct_exists(registred_commands, string_lower(curkey))
		keyhold += .1
	else
		keyhold = 0
	
	if keyhold >= 1 {
		active = false
		keyhold = 0
		keyboard_clear(vk_tab)
		curcommand = struct_get(registred_commands, string_lower(curkey)).execute
		
		event_user(0)
	}
}