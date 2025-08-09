if instance_exists(o_enc) 
	encounter_mode = true

if encounter_mode {
	textinst = instance_create(o_text_typer, 30, 376, depth-10)
	prefix = "{yspace(14)}"
}
else 
	textinst = instance_create(o_text_typer, xx + 26, yy + 20, depth-10)
	
textinst.text = prefix + text + postfix
textinst.gui = true
textinst.caller = id
textinst.destroy_caller = true

init = false