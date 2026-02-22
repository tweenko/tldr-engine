/// @desc starts a shop with given initial room, marker and direction
/// @arg {struct.shop} _shop_struct the shop struct
/// @arg {Asset.GMRoom} _return_room the room the player should return to when exiting the shop
/// @arg {any} _return_marker_id the id of the return marker
/// @arg {enum.DIR} _return_direction the direction the player should face when exiting the shop
/// @arg {bool} _fade_out whether the screen should fade out to black before starting the shop. true by default
function shop_start(_shop_struct, _return_room, _return_marker, _return_direction = undefined, _fade_out = true) {
    if !is_struct(_shop_struct)
        exit
    
    cutscene_create()
    cutscene_player_canmove(false)
    
    if _fade_out {
        cutscene_func(fader_fade, [0, 1, 15])
        cutscene_sleep(15)
    }
    cutscene_func(_shop_struct.start, [_return_room, _return_marker, _return_direction])
    
    cutscene_player_canmove(true)
    cutscene_play()
}