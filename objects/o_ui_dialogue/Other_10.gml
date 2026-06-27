alarm[0] = 0;

var create_typer = !(is_string(text) && string_length(text) == 0) || (is_array(text) && array_length(text) == 0);

if instance_exists(o_enc) 
	encounter_mode = true;
else if instance_exists(o_shop)
    shop_mode = true;

if encounter_mode {
    prefix = "{yspace(14)}" + prefix
    height = 130
    
    if create_typer
        textinst = text_typer_create(text, 30, 376, depth-10, prefix, postfix, {max_width: 540})
}
else if shop_mode {
    height = 170
    
    if create_typer
        textinst = text_typer_create(text, 30, 270, depth-10, prefix, postfix, {max_width: 540})
}
else if create_typer
	textinst = text_typer_create(text, xx + 26, yy + 20, depth-10, prefix, postfix, {max_width: 540})

if instance_exists(textinst) {
    textinst.gui = true
    textinst.caller = id
    textinst.destroy_caller = true
}

init = false