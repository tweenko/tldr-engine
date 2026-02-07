event_inherited()

item_list = [
	enc_set_ex,
	enc_set_virovirokun,
	ex_enc_set_shadowguys,
    ex_enc_set_spawn,
]
// feel free to add your encounters to the item list

select = function(_item) {
    instance_destroy()
    new _item()._start()
}
item_name = function(_item, _category, _item_index) {
    return enc_names[_category][_item_index]
}

item_categories = []
sort_items()

enc_names = [[]]
for (var i = 0; i < array_length(display_list); i++) {
    for (var j = 0; j < array_length(display_list[i].items); j ++) {
        enc_names[i][j] = script_get_name(display_list[i].items[j])
    }
}

show_debug_message(enc_names)