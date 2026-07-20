selection = 0
category = 0
scroll = 0
arrow_y = 0

item_list = []
item_blocked = []
item_categories = []

display_list = []

search_mode = false;
search_cursor_timer = 0;
search_input = "";
last_search_input = "";

global.console = true
depth = DEPTH_UI.CONSOLE

_select = function(_item) {}
_item_name = function(_item) {
    return "undefined"
} // should return a stirng

/// @arg {function} _filter_condition
_sort_items = function(_filter_condition = undefined) {
    last_search_input = search_input;
    display_list = [ {name: "uncategorized", keybind: ord("U"), items: [], color: c_white} ]
    
    var has_filter_condition = !is_undefined(_filter_condition);
    var __items_added = []
    for (var i = 0; i < array_length(item_categories); i ++) {
        if !has_filter_condition {
            __items_added = array_concat(__items_added, item_categories[i].items)
            array_push(display_list, item_categories[i])
        }
        else {
            var category = variable_clone(item_categories[i])
            category.items = [];
            
            for (var j = 0; j < array_length(item_categories[i].items); j ++) {
                var _item = item_categories[i].items[j];
                if !_filter_condition(_item)
                    continue;
                
                array_push(__items_added, _item);
                array_push(category.items, _item);
            }
            
            array_push(display_list, category);
        }
    }   
    
    for (var i = 0; i < array_length(item_list); i ++) {
        var __item = item_list[i]
        if array_contains(__items_added, __item)
            continue;
        if has_filter_condition && !_filter_condition(__item)
            continue;
        
        array_push(display_list[0].items, __item)
    }
}
_search_contains = function(_item) {
    return string_contains(search_input, _item_name(_item));
}

blacklist_keys = [
    vk_tab, vk_capslock, vk_shift, vk_control, vk_lcontrol, vk_alt, 
    vk_lalt, vk_lshift, vk_enter, vk_backspace, vk_numlock,
    vk_left, vk_right, vk_up, vk_down, vk_pagedown, vk_pageup,
    vk_f1, vk_f2, vk_f3, vk_f4, vk_f5, vk_f6, vk_f7, vk_f8, vk_f9, vk_f10, vk_f11, vk_f12,
    vk_insert, vk_delete, vk_decimal, vk_multiply, vk_menu, vk_escape, vk_space, vk_numlock, vk_end
];