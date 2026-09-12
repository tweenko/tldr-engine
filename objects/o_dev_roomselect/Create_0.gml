event_inherited()

var rm = room_first
var index = 0
while room_exists(rm) {
    array_push(item_list, rm)
    
    rm = room_next(rm)
    index ++
}

_select = function(_item) {
    instance_destroy()
    music_stop_all()
    audio_play(snd_ui_select)
    
    room_goto(_item)
}
_item_name = function(_item) {
    return room_get_name(_item)
}

item_categories = []

var tags_ignore = ["TLDR_Room_NoTracking"];
var unique_tags = [];
for (var i = 0; i < array_length(item_list); i ++) {
    var tags = asset_get_tags(item_list[i], asset_room);
    for (var j = 0; j < array_length(tags); j ++) {
        if !array_contains(unique_tags, tags[j]) && !array_contains(tags_ignore, tags[j])
            array_push(unique_tags, tags[j]);
    }
}

for (var i = 0; i < array_length(unique_tags); i ++) {
    array_push(item_categories, new _item_category(unique_tags[i], tag_get_asset_ids(unique_tags[i], asset_room)));
}

item_blocked = tag_get_asset_ids("TLDR_DebugExclude", asset_room);

_sort_items();