function shop() constructor {
    shopkeeper = o_shop_shopkeep
    
    flavor = "* Shop flavor text." // can be callable
    flavor_prefix = "" // used for links and voices
    
    bgm = noone
    bgm_pitch = 1
    bgm_gain = 1
    
    return_room = noone
    return_marker_id = 0
    return_direction = undefined
    
    options = [
        new shop_option_buy(
            [], 
            function(context) {
                return "Buy Text"
            }
        ),
        new shop_option_sell(),
        new shop_option_talk(
            [
                new __shop_talk_option("Talk Option", "* Talk Answer")
            ], 
            function(context) {
                return "Talk Text"
            }
        ),
        new shop_option_exit("* Leave Text"),
    ]
    
    start = method(self, function(_return_room, _return_marker_id, _return_direction = undefined) {
        room_goto(room_shop)
        fader_fade(1, 0, 15)
        
        return_room = _return_room
        return_marker_id = _return_marker_id
        return_direction = _return_direction
        
        call_later(1, time_source_units_frames, method(self, function() {
            with o_shop {
                shop_data = other
                event_user(0)
            }
        }))
    })
}