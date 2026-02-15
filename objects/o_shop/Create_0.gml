shop_data = {
    flavor: function() {
        return "* Welcome to Color Cafe.{br}{resetx}* Let us warm your day."
    },
    shopkeeper: o_ex_shop_shopkeep_swatch,
    options: [
        new shop_option_buy(),
        new shop_option_sell(),
        new shop_option_talk(),
        new shop_option_exit(),
    ]
}
event_user(0)

inst_flavor = noone

option_selection = 0

enum SHOP_MENU {
    OPTIONS,
}
menu = SHOP_MENU.OPTIONS

__get_flavor = function() {
    return (is_callable(shop_data.flavor) ? shop_data.flavor() : shop_data.flavor)
}