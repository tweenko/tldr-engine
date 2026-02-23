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