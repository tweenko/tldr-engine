event_inherited();

select = function(_item) {
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

item_name = function(_item, _category, _item_index) {
    return object_get_name(_item);
}

item_categories = [
	{
		name : "Examples",
		keybind : ord("E"),
		color: c_aqua,
		items: tag_get_asset_ids("TLDR_Intro_Example", asset_object)
	},
	
	{
		name : "DELTARUNE",
		keybind : ord("D"),
		color: c_white,
		items: tag_get_asset_ids("TLDR_Intro_DR", asset_object)
	},
	
	{
        name: "Unfinished",
        keybind: ord("U"),
        color: c_purple,
        items: tag_get_asset_ids("TLDR_Intro_NotDone", asset_object)
    },
	
	{
		name : "Unavailable",
		keybind: -1,
		color: c_dkgray,
		items: tag_get_asset_ids("TLDR_Intro_NoPick", asset_object)
	},
]

item_blocked = tag_get_asset_ids(["TLDR_Intro_NoPick"], asset_object);
item_list = tag_get_asset_ids("TLDR_Intro", asset_object);

sort_items();