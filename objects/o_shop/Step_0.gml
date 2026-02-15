if menu == SHOP_MENU.OPTIONS {
    if !instance_exists(inst_flavor) {
        inst_flavor = text_typer_create(__get_flavor(), 30, 270, DEPTH_UI.MENU_UI,, "", {
            can_superskip: false,
            gui: true,
            max_width: 370
        })
    }
    
    if InputPressed(INPUT_VERB.DOWN) {
        option_selection ++
    }
    else if InputPressed(INPUT_VERB.UP) {
        option_selection --
    }
    option_selection = cap_wraparound(option_selection, array_length(shop_data.options))
}