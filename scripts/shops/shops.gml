function shop() constructor {
    shopkeeper = o_shop_shopkeep
    
    flavor = "* Shop flavor text." // can be callable
    flavor_prefix = "" // used for links and voices
    
    options = [
        new shop_option_buy(
            [], 
            function(context) {
                return "Side Talking"
            }
        ),
        new shop_option_sell(),
        new shop_option_talk(),
        new shop_option_exit(),
    ]
}

function ex_shop_color_cafe() : shop() constructor {
    shopkeeper = o_ex_shop_shopkeep_swatch
    
    flavor_counter = 0
    flavor = function(context) {
        if flavor_counter > 0
            return "* Don't be blue.{br}{resetx}* We're here for you."
            
        flavor_counter ++
        return "* Welcome to Color Cafe.{br}{resetx}* Let us warm your day."
    }
    flavor_prefix = "{link(0, true, `o_shop_shopkeep`)}"
    
    items = [
        new ex_item_butjuice(),
        new ex_item_spagetticode(),
        new ex_item_a_bshotbowtie(),
        new ex_item_a_royalpin()
    ]
    options = [
        new shop_option_buy(
            items, 
            function(context) {
                switch context {
                    case SHOP_TALK_CONTEXT.IDLE:
                        return "Our menu is specially prepared."
                        
                    case SHOP_TALK_CONTEXT.BOUGHT:
                        return "Queen thanks you for your patronage."
                    case SHOP_TALK_CONTEXT.BOUGHT_STORAGE:
                        return "Thanks, it'll be in your STORAGE."
                        
                    case SHOP_TALK_CONTEXT.CANCELED:
                        return "Take your time. We'll be waiting."
                        
                    case SHOP_TALK_CONTEXT.NOT_ENOUGH:
                        return "You can't afford it. ... maybe next time?"
                    case SHOP_TALK_CONTEXT.NO_SPACE:
                        return "{auto_breaks(false)}Seems your{br}bags are{br}full. Shall{br}we assist?"
                }
            }
        ),
        new shop_option_sell(),
        new shop_option_talk(),
        new shop_option_exit(),
    ]
}