/// @description execute command
var arg = []

var __temp_arg = ""
var __string_mode = false
for (var i = 1; i <= string_length(argstrings); i ++) {
    var __char = string_char_at(argstrings, i)
    
    if __char == "`"
        __string_mode = !__string_mode
    else if __char == "," && !__string_mode {
        __temp_arg = string_trim_start(__temp_arg)
        array_push(arg, __temp_arg)
        
        __temp_arg = ""
    }
    else
        __temp_arg += __char
}

// add the last recorded argument as well
if __temp_arg != "" {
    __temp_arg = string_trim_start(__temp_arg)
    array_push(arg, __temp_arg)
}

if command == "s" || command == "sleep" { // sleep(frames)
	if array_length(arg) > 0
		pause = real(arg[0])
	else
		show_error("Command sleep recieved no arguments",true)
	
	looping = false
}
if command == "br" { // br() or br
	chars ++
}
if command == "p" || command == "pause"  { // pause(frames)
	pause = -1
	looping = false
    superskipping_buffer = 2
}
if command == "c" || command == "clear"  { // clear() OR clear
	event_user(2)
}
if command == "e" || command == "end" { // end() OR end
	event_user(3)
}
if command == "stop" { // stop() or stop
	pause = -2
}
	
if command == "auto_pauses" { // auto_pauses(bool)
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
if command == "auto_breaks" { // auto_breaks(bool)
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
if command == "break_system" { // break_system(language_id = string)
	break_system = arg[0]
}

if command == "instant" { // instant(bool = true)
    var __arg = true
    if array_length(arg) > 0
        __arg = arg[0]
    
	skipping = __arg
}
if command == "break_tabulation" { // break_tabulation(bool)
	break_tabulation = bool(arg[0])
}
if command == "preset" { // preset(type) out of "enemy_text", "god_text", "light_world"
	if arg[0] == "enemy_text" {
		break_tabulation = false
		font = loc_font("enc")
		shadow = false
		xscale = 1
		yscale = 1
		xcolor = c_black
		yspace = 20
	}
	if arg[0] == "god_text" {
		break_tabulation = false
		shadow = false
		god = true
		
		xspace = 5
		yspace = 20
		
		typespd = 2
		voice = -1
	}
    if arg[0] == "light_world" {
		shadow = false
	}
}
if command == "box_pos" { // box_pos(bool)
    caller._reposition_self_to(arg[0])
}

if command == "col" || command == "color" { // col(string) OR color(string)
	saved_color = xcolor
	xcolor = string_to_color(arg[0])
	if arg[0] == "tired_aqua" 
		xcolor = merge_color(c_aqua, c_blue, 0.3)
}
if command == "solid_col" || command = "solid_color" { // solid_col(bool)
    solid_color = arg[0]
}
if command == "reset_col" { // reset_col() OR reset_col
	xcolor = saved_color
}
if command == "font" { // font(string) out of "main", "text", "enc"
	if arg[0] == "enc"
		font = loc_font("enc")
	else if arg[0] == "text"
		font = loc_font("text")
	else if arg[0] == "main"
		font = loc_font("main")
	else{
		font=asset_get_index(arg[0])
	}
}
if command == "shadow" { // shadow(bool)
	shadow = bool(arg[0])
}
if command == "eff" || command == "effect" { // eff(real) out of 0 (shake)
    effect = real(arg[0])
}
if command == "god" { // god(bool)  whether it's god (gaster) text
	god = bool(arg[0])
}
if command == "npc_link" { // npc_link(real)  you can link an npc to this and they will be animated when the text is playing
	var o_link = real(arg[0])
	
	var o = noone
	with(o_ow_npc) {
		if o_link == npc_id {
			o = id
		}
	}
	
	npc_link = o
}
if command == "choice" { // choice(choice1, choice2, ...)  create a choice box for the player
	choice_inst = instance_create(o_text_choice, x, y, depth, {
		choices: arg,
		caller: id,
	})
    
	pause = -2
	looping = false
    
    choice_save_allow_skip = allow_skip_internal
    
    skipping = false
    superskipping = false
    allow_skip_internal = false
}

if command == "xscale" { // xscale(real)
	xscale = real(arg[0])
}
if command == "yscale" { // yscale(real)
	yscale = real(arg[0])
}
if command == "scale" { // scale(real)
	xscale = real(arg[0])
	yscale = real(arg[0])
}
if command == "xspace" { // xspace(real)
	xspace = real(arg[0])
}
if command == "yspace" { // yspace(real)
	yspace = real(arg[0])
}
if command == "resetx" { // resetx() OR resetx  reset the x position of the typer
	xoff = 0
	chars ++
}

if command == "spr" || command == "sprite" { // spr(sprite_index) OR sprite(sprite_index)  inserts a sprite into the text
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
if command == "sound" || command == "snd" { // snd(sound_index) OR sound(sound_index)  plays a sound 
    var snd = asset_get_index(arg[0])
    
    if audio_exists(snd)
        audio_play(snd)
}

if command == "can_skip" { // can_skip(bool)
	can_skip = bool(arg[0])
    if !can_skip {
        allow_skip_internal = false
        skipping = false
        superskipping = false
    }
}
if command == "speed" { // speed(real)
	typespd = real(arg[0])
}

if command == "char" { // char(char_preset_string, face_expression = undefined)  optional argument 1 for changing the expression - could be either the name of the expression or the index of it in the sprite
	var __exp = (array_length(arg) > 1 ? real(arg[1]) : 0)
	_facechange(arg[0], __exp)
	
	voice = struct_get(struct_get(char_presets, arg[0]), "voice")
	voice_pitch_calc = struct_get(struct_get(char_presets, arg[0]), "voice_pitch_calc")
	voice_interrupt = struct_get(struct_get(char_presets, arg[0]), "voice_interrupt")
	voice_skip = struct_get(struct_get(char_presets, arg[0]), "voice_skip")
    voice_pitchrange = undefined
	
	char = arg[0]
	looping = false
}
if command == "face" { // face(face_preset_string, face_expression)  optional argument 1 for changing the expression - could be either the name of the expression or the index of it in the sprite
	var __exp = (array_length(arg) > 1 ? real(arg[1]) : 0)
	_facechange(arg[0], __exp)
	looping = false
}
if command == "f_ex" || command == "face_ex" { // f_ex(string OR real) OR face_ex(string OR real)
	face_expression = arg[0]
    if string_length(face_expression) == string_length(string_digits(face_expression))
        face_expression = real(face_expression)
}
if command == "voice" { // voice(asset OR nil, pitch_range = undefined, interrupt = undefined, skip_frames = undefined)  write it with the `` things
    voice_pitchrange = undefined
    
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

if command == "mini" { // mini(text, char = undefined, face_expression = undefined, x = auto, y = auto)
    var __char = undefined
    var __face_ex = 0
    var __xx = x + 386 - string_width(arg[0])
    var __yy = y + 64
    
    if array_length(arg) > 1 __char = arg[1]
    if array_length(arg) > 2 __face_ex = arg[2]
    if array_length(arg) > 3 __xx += real(arg[3])
    if array_length(arg) > 4 __yy += real(arg[4])
        
    if string_length(string_digits(__face_ex)) == string_length(__face_ex)
        __face_ex = real(__face_ex)
    
    array_push(mini_faces, 
        instance_create(o_text_mini, __xx, __yy, depth, {
            x: __xx, y: __yy,
            face_creator: struct_get(struct_get(char_presets, __char), "face_create"),
            face_expression: __face_ex,
            text: arg[0]
        })
    )
}

argstrings = ""