event_inherited()

item_list = [
	enc_set_ex,
	enc_set_virovirokun,
	ex_enc_set_shadowguys,
    ex_enc_set_spawn,
]
// feel free to add your encounters to the item list

_select = function(_item) {
    instance_destroy()
    new _item()._start()
}
_item_name = function(_item) {
    return script_get_name(_item);
}

item_categories = []
_sort_items()