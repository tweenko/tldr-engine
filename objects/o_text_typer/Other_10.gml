/// @description execute command
var arg = string_split(argstrings,", ")

if command == "s" || command == "sleep" { //sleep
	if array_length(arg)>0
		pause = real(arg[0])
	else
		show_error("Command sleep recieved no arguments",true)
	
	looping = false
}
if command == "br" || command == "break" {
	chars ++
}
if command == "p" || command == "pause"  { // pause
	pause = -1
	looping=  false
}
if command == "c" || command == "clear"  { // clear
	event_user(2)
}
if command == "e" || command == "end" { // end
	event_user(3)
}
if command == "stop" {
	pause = -2
}
	
if command == "auto_pauses" {
	var __a = string(arg[0])
	if __a == "true" 
		|| __a == "false"
		|| __a == "0"
		|| __a == "1"
	{
		auto_pauses = bool(__a)
	}
	else
		show_error("Command auto_pauses recieved a non-boolean argument", true)
}
if command == "auto_breaks" {
	var __a = string(arg[0])
	if __a == "true" 
		|| __a == "false"
		|| __a == "0"
		|| __a == "1"
	{
		auto_breaks = bool(__a)
	}
	else
		show_error("Command auto_breaks recieved a non-boolean argument", true)
}

if command == "instant" {
	skipping = true
}
if command == "break_tabulation" {
	break_tabulation = real(arg[0])
}
if command == "preset" {
	if arg[0] == "enemy_text" {
		break_tabulation = 1
		font = loc_getfont("enc")
		shadow = false
		xscale = 1
		yscale = 1
		xcolor = c_black
		yspace = 20
	}
	if arg[0] == "god_text" {
		break_tabulation = 1
		shadow = false
		god = true
		
		xspace = 5
		yspace = 20
		
		typespd = 2
		voice = -1
	}
}

if command == "col" {
	saved_color = xcolor
	xcolor = string_to_color(arg[0])
	if arg[0] == "tired_aqua" 
		xcolor = merge_color(c_aqua, c_blue, 0.3)
}
if command == "reset_col" {
	xcolor = saved_color
}
if command == "font" {
	if arg[0] == "enc"
		font = loc_getfont("enc")
	else if arg[0] == "text"
		font = loc_getfont("text")
	else if arg[0] == "main"
		font = loc_getfont("main")
	else{
		font=asset_get_index(arg[0])
	}
}
if command == "shadow" {
	shadow = bool(arg[0])
}
if command == "eff" {
	effect = real(arg[0])
}
if command == "god" {
	god = bool(arg[0])
}
if command == "npc_link" {
	var o_link = real(arg[0])
	
	var o = noone
	with(o_ow_npc) {
		if o_link == npc_id {
			o = id
		}
	}
	
	npc_link = o
}
if command == "choice"{
	choice_inst = instance_create(o_text_choice, x, y, depth, {
		choices: arg,
		caller: id,
	})
	pause = -2
	looping = false
}

if command == "xscale" {
	xscale = real(arg[0])
}
if command == "yscale" {
	yscale = real(arg[0])
}
if command == "scale" {
	xscale = real(arg[0])
	yscale = real(arg[0])
}
if command == "xspace" {
	xspace = real(arg[0])
}
if command == "yspace" {
	yspace = real(arg[0])
}
if command == "resetx" { // reset the x position of the typer
	xoff = 0
	chars ++
}

if command == "spr" {
	var spr = asset_get_index(arg[0])
	var inst = instance_create(o_text_single, x + xoff, y + yoff, depth)
	
	array_push(mychars, inst)
	
	inst.symbol = ""
	inst.font = font
	inst.gui = gui
	inst.scalex = xscale
	inst.scaley = yscale
	inst.xcolor = xcolor
	inst.font = font
	inst.shadow = shadow
	inst.effect = effect
	inst.timer = chartimeroff * chars
	inst.god = god
	inst.sprite = spr
			
	xoff += sprite_get_width(spr)*xscale
	xoff += xspace * xscale
}
if command == "can_skip" {
	can_skip = bool(arg[0])
}
if command == "speed" {
	typespd = real(arg[0])
}

if command == "char" { // optional argument 1 for changing the expression
	var __exp = (array_length(arg) > 1 ? arg[1] : "neutral")
	_facechange(arg[0], __exp)
	
	voice = struct_get(struct_get(char_presets, arg[0]), "voice")
	voice_pitchrange = struct_get(struct_get(char_presets, arg[0]), "voice_pitchrange")
	voice_interrupt = struct_get(struct_get(char_presets, arg[0]), "voice_interrupt")
	voice_skip = struct_get(struct_get(char_presets, arg[0]), "voice_skip")
	
	char = arg[0]
	looping = false
}
if command == "face" { // optional argument 1 for changing the expression
	var __exp = (array_length(arg) > 1 ? arg[1] : "neutral")
	_facechange(arg[0], __exp)
	looping = false
}
if command == "f_ex" || command == "face_ex" {
	face_expression = arg[0]
}
if command == "voice" {
	if array_length(arg) > 0 {
		if arg[0] == "nil"
			voice = -1
		else
			voice = asset_get_index(arg[0])
	}
	if array_length(arg) > 1 && arg[1] != "nil" {
		voice_pitchrange = arg[1]
		voice_pitchrange = string_copy(voice_pitchrange, 1, string_width(voice_pitchrange)-2)
		voice_pitchrange = string_split(voice_pitchrange, ",")
	}
	if array_length(arg) > 2 && arg[2] != "nil" 
		voice_interrupt = bool(arg[2])
	if array_length(arg) > 3 && arg[3] != "nil" 
		voice_skip = bool(arg[3])
}

argstrings=""