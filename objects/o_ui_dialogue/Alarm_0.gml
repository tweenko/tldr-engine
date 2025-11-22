if instance_exists(o_enc) 
	encounter_mode = true

if encounter_mode {
    prefix += "{yspace(14)}"
	textinst = text_typer_create(text, 30, 376, depth-10, prefix, postfix)
}
else 
	textinst = text_typer_create(text, xx + 26, yy + 20, depth-10, prefix, postfix)
	
textinst.gui = true
textinst.caller = id
textinst.destroy_caller = true

init = false