items = [
    new ex_item_butjuice(),
    new ex_item_spagetticode(),
    new ex_item_a_bshotbowtie(),
    new ex_item_a_royalpin()
]

shop_data = {
    flavor: function() {
        return "* Welcome to Color Cafe.{br}{resetx}* Let us warm your day."
    },
    flavor_prefix: "{link(0, true, `o_shop_shopkeep`)}",
    
    shopkeeper: o_ex_shop_shopkeep_swatch,
    options: [
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
                        return "Seems your bags are full. Shall we assist?"
                }
            }
        ),
        new shop_option_sell(),
        new shop_option_talk(),
        new shop_option_exit(),
    ]
}
event_user(0)

inst_flavor = noone
inst_small_talk = noone
inst_shopkeeper = noone

option_selection = 0
selection = 0

menu_drawer = undefined
menu_step = undefined

menu_in_options = true

__get_flavor = function() {
    return (is_callable(shop_data.flavor) ? shop_data.flavor() : shop_data.flavor)
}