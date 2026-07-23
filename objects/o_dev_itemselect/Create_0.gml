event_inherited()

_select = function(_item) {
    
}
_item_name = function(_item) {
    return script_get_name(_item);
}

item_list = tag_get_asset_ids(AssetTag_item, asset_script);

var list_exclude = tag_get_asset_ids(AssetTag_item_spell, asset_script);
for (var i = 0; i < array_length(list_exclude); i ++) {
    array_delete_by_value(item_list, list_exclude[i]);
}

var unique_tags = [];
var exclude_tags = [AssetTag_item];

for (var i = 0; i < array_length(item_list); i ++) {
    var tags = asset_get_tags(item_list[i], asset_script);
    for (var j = 0; j < array_length(tags); j ++) {
        if !array_contains(unique_tags, tags[j]) && string_contains("TLDR_", tags[j]) && !array_contains(exclude_tags, tags[j])
            array_push(unique_tags, tags[j]);
    }
}

for (var i = 0; i < array_length(unique_tags); i ++) {
    array_push(item_categories, new _item_category(unique_tags[i], tag_get_asset_ids(unique_tags[i], asset_script)));
}

item_blocked = tag_get_asset_ids("TLDR_DebugExclude", asset_script);

_sort_items();

hovered_item = undefined;
selection_prev = selection;
hover_timer = 0;