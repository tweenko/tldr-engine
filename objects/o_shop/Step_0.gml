if menu_in_options {
    if !instance_exists(inst_flavor) {
        inst_flavor = text_typer_create(__get_flavor(), 30, 270, DEPTH_UI.MENU_UI, shop_data.flavor_prefix, "", {
            can_superskip: false,
            gui: true,
            max_width: 370
        })
    }
    
    if InputPressed(INPUT_VERB.DOWN)
        option_selection ++
    else if InputPressed(INPUT_VERB.UP)
        option_selection --
    option_selection = cap_wraparound(option_selection, array_length(shop_data.options))
    
    if InputPressed(INPUT_VERB.SELECT) {
        if !shop_data.options[option_selection].enabled
            audio_play(snd_ui_cant_select)
        else {
            audio_play(snd_ui_select)
            menu_drawer = shop_data.options[option_selection].drawer
            menu_step = shop_data.options[option_selection].step
            menu_in_options = false
            
            shop_data.options[option_selection].use()
        }
    }
}
else {
    if !is_undefined(menu_step)
        menu_step()
}

if !menu_in_options {
    if instance_exists(inst_flavor)
        instance_destroy(inst_flavor)
}
if menu_in_options {
    if instance_exists(inst_small_talk)
        instance_destroy(inst_small_talk)
}