global.console = true

if !search_mode {
    // menu movement
    if keyboard_check_repeat(vk_up) {
    	selection --
        
    	if selection < 0 {
            category --;
            while category >= 0 && array_length(display_list[category].items) == 0
                category --;
            
            if category < 0 {
                search_mode = true;
                search_cursor_timer = 0;
                keyboard_string = "";
                exit;
            }
            
            selection = array_length(display_list[category].items) - 1
        }
    }
    if keyboard_check_repeat(vk_down) {
        selection ++
        
        var save_category = category;
        if selection >= array_length(display_list[category].items) {
            category ++;
            while category < array_length(display_list) && array_length(display_list[category].items) == 0
                category ++;
            
            if category >= array_length(display_list) {
                category = save_category;
                selection = array_length(display_list[category].items) - 1;
            }
            else 
                selection = 0;
        }
    }
    
    scroll = lerp(scroll, max(0, arrow_y - GAME_H_GUI/2 - 40), .3);
    
    if keyboard_check_pressed(vk_enter) {
    	if !array_contains(item_blocked, display_list[category].items[selection]) 
            _select(display_list[category].items[selection])
    	else 
    		audio_play(snd_ui_cant_select)
    }
    
    if keyboard_check_pressed(vk_anykey) && !array_contains(blacklist_keys, keyboard_key) {
        if keyboard_string != "" {
            var possible_chr = string_char_at(keyboard_string, string_length(keyboard_string));
            if ord(possible_chr) > ord("0") && ord(possible_chr) < ord("z") {
                search_mode = true;
                search_cursor_timer = 0;
                search_input = possible_chr;
                keyboard_string = "";
            }
        }
        _sort_items(_search_contains);
    }
}
else {
    arrow_y = 0;
    scroll = lerp(scroll, 0, .3);
    
    if keyboard_check_pressed(vk_down) || keyboard_check_pressed(vk_enter) {
        search_mode = false;
        
        category = 0;
        selection = 0;
        
        while category < array_length(display_list) && selection >= array_length(display_list[category].items) {
            selection = 0
            category ++
        }
        if category >= array_length(display_list) {
            search_mode = true;
        }
        
        if !search_mode && keyboard_check_pressed(vk_enter) {
            if !array_contains(item_blocked, display_list[category].items[selection]) 
                _select(display_list[category].items[selection])
        	else 
        		audio_play(snd_ui_cant_select)
        }
    }
    
    if keyboard_check_pressed(vk_anykey) && !array_contains(blacklist_keys, keyboard_key) {
        if keyboard_string != "" {
            var possible_chr = string_char_at(keyboard_string, string_length(keyboard_string));
            if ord(possible_chr) > ord("0") && ord(possible_chr) < ord("z") {
                search_input += possible_chr;
                search_cursor_timer = 0;
            }
            
            keyboard_string = "";
        }
        _sort_items(_search_contains);
    }
    if keyboard_check_repeat(vk_backspace, 2) && string_length(search_input) > 0 {
        search_input = string_delete(search_input, string_length(search_input), 1);
        search_cursor_timer = 0;
        _sort_items(_search_contains);
    }
    
    if keyboard_check_pressed(vk_anykey) && string_length(search_input) == 0 {
        _sort_items();
    }
    
    search_cursor_timer ++;
}

if keyboard_check_pressed(vk_escape) {
    instance_destroy()
}