selection = 0
category = 0
scroll = 0
soul_y = 0

item_list = []
item_blocked = []
item_categories = []

display_list = []

global.console = true
depth = DEPTH_UI.CONSOLE

select = function(_item) {}
item_name = function(_item, _category, _item_index) {
    return "undefined"
} // should return a stirng

sort_items = function() {
    display_list = [ {name: "uncategorized", keybind: ord("U"), items: [], color: c_white} ]
    
    var __items_added = []
    for (var i = 0; i < array_length(item_categories); i ++) {
        __items_added = array_concat(__items_added, item_categories[i].items)
        array_push(display_list, item_categories[i])
    }   
    
    for (var i = 0; i < array_length(item_list); i ++) {
        var __item = item_list[i]
        if array_contains(__items_added, __item)
            continue
        
        array_push(display_list[0].items, __item)
    }
}