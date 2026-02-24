/// @desc starts a full-screen shop with given initial room, marker and direction.
/// @arg {struct.shop} _shop_struct the shop struct
/// @arg {Asset.GMRoom} _return_room the room the player should return to when exiting the shop
/// @arg {any} _return_marker_id the id of the return marker
/// @arg {enum.DIR} _return_direction the direction the player should face when exiting the shop
/// @arg {bool} _fade_out whether the screen should fade out to black before starting the shop. true by default
function shop_start(_shop_struct, _return_room, _return_marker_id, _return_direction = undefined, _fade_out = true) {
    if !is_struct(_shop_struct)
        exit
    
    cutscene_create()
    cutscene_player_canmove(false)
    
    if _fade_out {
        if asset_get_index(_shop_struct.bgm) != -1
            cutscene_func(music_fade, [0, 0, 15])
        cutscene_func(fader_fade, [0, 1, 15])
        cutscene_sleep(15)
    }
    
    cutscene_func(function(_shop_struct, _return_room, _return_marker_id, _return_direction) {
        room_goto(room_shop)
        fader_fade(1, 0, 15)
        
        with _shop_struct {
            return_room = _return_room
            return_marker_id = _return_marker_id
            return_direction = _return_direction
        }
        
        call_later(1, time_source_units_frames, method(_shop_struct, function() {
            start()
        }))
    }, [_shop_struct, _return_room, _return_marker_id, _return_direction])
    cutscene_player_canmove(true)
    cutscene_play()
}

/// @desc starts an overworld shop
/// @arg {struct.shop} _shop_struct the shop struct
function shop_ow_start(_shop_struct) {
    if !is_struct(_shop_struct)
        exit
    
    _shop_struct.start()
}

/// @desc sets a hash of the `SHOP_DATA` entry to a value
/// @arg {string|struct.shop} shop_instance the instance of the shop. will be the hash used in the shop data
/// @arg {string} hash the hash INSIDE the shop instance of choice
/// @arg {any} value the value you'd like to set the shop data to
function shop_data_set(shop_instance, hash, value) {
    if !is_string(shop_instance)
        shop_instance = instanceof(shop_instance)
    var ds = struct_get(save_get("SHOP_DATA"), shop_instance)
    struct_set(ds, hash, value)
}

/// @desc gets a value from the `SHOP_DATA` entry's certain shop instance
/// @arg {string|struct.shop} shop_instance the instance of the shop. will be the hash used in the shop data
/// @arg {string} hash the hash INSIDE the shop instance of choice
function shop_data_get(shop_instance, hash) {
    if !is_string(shop_instance)
        shop_instance = instanceof(shop_instance)
    var ds = struct_get(save_get("SHOP_DATA"), shop_instance)
    return struct_get(ds, hash)
}

/// @desc changes a value from the `SHOP_DATA` entry's certain shop instance
/// @arg {string|struct.shop} shop_instance the instance of the shop. will be the hash used in the shop data
/// @arg {string} hash the hash INSIDE the shop instance of choice
/// @arg {real|struct} change the amount you'd like to change this certain data by
function shop_data_change(shop_instance, hash, change) {
    if is_struct(change) {
        var new_struct = shop_data_get(shop_instance, hash)
        var struct_names = struct_get_names(change)
        for (var i = 0; i < array_length(struct_names); i ++) {
            var base_val = (struct_exists(new_struct, struct_names[i]) 
                ? struct_get(new_struct, struct_names[i])
                : 0
            )
            var new_val = struct_get(change, struct_names[i])
            
            struct_set(new_struct, struct_names[i], base_val + new_val)
        }
    
        shop_data_set(shop_instance, hash, new_struct)
    }
    else 
        shop_data_set(shop_instance, hash, shop_data_get(shop_instance, hash) + change)
}

/// @desc accounts for an item being bought in a certain shop and adds it to shop data
/// @arg {string|struct.shop} shop_instance the instance of the shop. will be the hash used in the shop data
/// @arg {struct.item} item_struct the item struct
function shop_data_item_eval(shop_instance, item_struct) {
    var item_instance = instanceof(item_struct)
    var default_val = item_get_in_stock(item_struct)
    var change_struct = {}
    
    if !is_string(shop_instance)
        shop_instance = instanceof(shop_instance)
    
    struct_set(change_struct, item_instance, -1)
    
    if !struct_exists(save_get("SHOP_DATA"), shop_instance)
        struct_set(save_get("SHOP_DATA"), shop_instance, {item_stock: {}})
    if !struct_exists(shop_data_get(shop_instance, "item_stock"), item_instance)
        struct_set(shop_data_get(shop_instance, "item_stock"), item_instance, default_val)
    
    shop_data_change(shop_instance, "item_stock", change_struct)
}

/// @desc gets the amount of an item available in a shop
/// @arg {string|struct.shop} shop_instance the instance of the shop. will be the hash used in the shop data
/// @arg {struct.item} item_struct the item struct
function shop_get_in_stock(shop_instance, item_struct) {
    var item_instance = instanceof(item_struct)
    if !is_string(shop_instance)
        shop_instance = instanceof(shop_instance)
    
    if struct_exists(save_get("SHOP_DATA"), shop_instance) 
        && struct_exists(shop_data_get(shop_instance, "item_stock"), item_instance)
    {
        return struct_get(shop_data_get(shop_instance, "item_stock"), item_instance)
    }
    else
        return item_get_in_stock(item_struct)
}