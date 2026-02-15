if instance_exists(o_enc) 
	encounter_mode = true
else if instance_exists(o_shop)
    shop_mode = true

if encounter_mode {
    prefix = "{yspace(14)}" + prefix
	textinst = text_typer_create(text, 30, 376, depth-10, prefix, postfix, {max_width: 540})
    height = 130
}
else if shop_mode {
    textinst = text_typer_create(text, 30, 376, depth-10, prefix, postfix, {max_width: 540})
    height = 170
}
else 
	textinst = text_typer_create(text, xx + 26, yy + 20, depth-10, prefix, postfix, {max_width: 540})
	
textinst.gui = true
textinst.caller = id
textinst.destroy_caller = true

init = false