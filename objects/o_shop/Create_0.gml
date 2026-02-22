shop_data = new ex_shop_color_cafe()
event_user(0)

inst_flavor = noone
inst_small_talk = noone
inst_shopkeeper = noone

option_selection = 0
selection = 0
waiting = false
waiting_internal = false

menu_drawer = undefined
menu_step = undefined
menu_in_options = true
menu_expanded = false

__get_flavor = function() {
    return (is_callable(shop_data.flavor) ? shop_data.flavor() : shop_data.flavor)
}
__get_waiting = function() {
    return waiting || waiting_internal
}