event_inherited()

item_list = [
	enc_set_ex,
	enc_set_virovirokun,
	ex_enc_set_shadowguys,
    ex_enc_set_spawn,
]
// feel free to add your encounters to the item list

enc_names = []
for (var i = 0; i < array_length(item_list); i++){
	enc_names[i] = script_get_name(item_list[i])
}

select = function(_item, _item_index) {
    instance_destroy()
    new _item()._start()
}
item_name = function(_item, _item_index) {
    return enc_names[_item_index]
}