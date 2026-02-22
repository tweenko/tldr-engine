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
    
    bgm = mus_ex_hip_shop
    bgm_pitch = 1
    bgm_gain = .97
    
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
                        return loc("ex_shop_color_cafe_buy_idle")
                        
                    case SHOP_TALK_CONTEXT.BOUGHT:
                        return loc("ex_shop_color_cafe_buy_bought")
                    case SHOP_TALK_CONTEXT.BOUGHT_STORAGE:
                        return loc("ex_shop_color_cafe_buy_bought_storage")
                        
                    case SHOP_TALK_CONTEXT.CANCELED:
                        return loc("ex_shop_color_cafe_buy_canceled")
                        
                    case SHOP_TALK_CONTEXT.NOT_ENOUGH:
                        return loc("ex_shop_color_cafe_buy_not_enough")
                    case SHOP_TALK_CONTEXT.NO_SPACE:
                        return loc("ex_shop_color_cafe_buy_no_space")
                }
            }
        ),
        new shop_option_sell(, function(context) {
            switch context {
                case SHOP_TALK_CONTEXT.IDLE:
                    return loc("ex_shop_color_cafe_sell_idle")
                case SHOP_TALK_CONTEXT.CANCELED:
                    return loc("ex_shop_color_cafe_sell_canceled")
                case SHOP_TALK_CONTEXT.REFUSE:
                    return loc("ex_shop_color_cafe_sell_refuse")
                    
                case SHOP_TALK_CONTEXT.NO_ITEMS:
                    return loc("ex_shop_color_cafe_sell_no_items")
                case SHOP_TALK_CONTEXT.SELL_CONSUMABLE:
                    return loc("ex_shop_color_cafe_sell_consumable")
                case SHOP_TALK_CONTEXT.SELL_WEAPON:
                    return loc("ex_shop_color_cafe_sell_weapon")
                case SHOP_TALK_CONTEXT.SELL_ARMOR:
                    return loc("ex_shop_color_cafe_sell_armor")
                case SHOP_TALK_CONTEXT.SOLD:
                    return loc("ex_shop_color_cafe_sell_sold")
            }
        }),
        new shop_option_talk([
            new __shop_talk_option("Talk Option", "Talk Answer")
        ], function(context) {
            return loc("ex_shop_color_cafe_talk_idle")
        }),
        new shop_option_exit(loc("ex_shop_color_cafe_leave")),
    ]
}