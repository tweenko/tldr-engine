function shop() constructor {
    shopkeeper = undefined // can be undefined
    shopkeeper_x = 160
    shopkeeper_y = 120
    
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
            [], 
            function(context) {
                return "Talk Text"
            }
        ),
        new shop_option_exit("* Leave Text"),
    ]
    
    start = method(self, function() {
        var inst = instance_create(o_shop)
        with inst {
            shop_data = other
            event_user(0)
        }
    })
}