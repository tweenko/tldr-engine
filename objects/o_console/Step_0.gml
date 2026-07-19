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
    held_keys = get_all_pressed_keys();
    var target_command = command_find(held_keys);
    
	if !is_undefined(target_command)
		keyhold ++
	else
		keyhold = 0
	
	if keyhold >= keyhold_max {
		active = false
		keyhold = 0
        
		keyboard_clear(vk_tab);
		curcommand = target_command.execute;
		
		event_user(0);
	}
}