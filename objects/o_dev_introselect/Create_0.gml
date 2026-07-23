event_inherited();

_select = function(_item) {
    instance_destroy()
    music_stop_all()
    audio_play(snd_ui_select)
    
	room_instance_clear(room_intro);
	room_goto(room_intro);
	
	cutscene_create(false);
	cutscene_wait_until(function(){return room == room_intro});
	cutscene_func(function(_i){
		if !instance_exists(_i) {
			with instance_create(_i) {
				__intro_init(true);
			}
		}
	}, _item);
	cutscene_play();
}

_item_name = function(_item, _category, _item_index) {
    return object_get_name(_item);
}

item_categories = [
    new _item_category("Examples", tag_get_asset_ids("TLDR_Intro_Example", asset_object)),
    new _item_category("DELTARUNE", tag_get_asset_ids("TLDR_Intro_DR", asset_object)),
    new _item_category("Unavailable", tag_get_asset_ids("TLDR_Intro_NoPick", asset_object)),
]

item_blocked = tag_get_asset_ids(["TLDR_Intro_NoPick"], asset_object);
item_list = tag_get_asset_ids("TLDR_Intro", asset_object);

_sort_items();