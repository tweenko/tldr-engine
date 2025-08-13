/// @description write
var normalupd = true

while looping || normalupd {
	var curchar = string_char_at(text, 0)
	
	// start checking for commands upon reaching a bracket
	if string_char_at(text, 0) == "{" {
		text = string_delete(text, 0, 1)
		command = ""
		command_mode = true
	}
	
	// type out the text
	if !command_mode {
		if init {
			event_user(1);
			init = false
		}
		if timer % typespd == 0 && pause == 0 {
			draw_set_font(font)
			
			var __v = voice
			// choose the voice blip randomly if it's an array
			if is_array(voice)
				__v = array_shuffle(__v)[0]
			if audio_exists(__v) && !skipping && timer % voice_skip == 0{
				var pitch = 1
				
				// stop the previous sounds if ordered to
				if struct_get(char_presets, char).voice_interrupt{
					audio_stop_sound(__v)
					
					// stop all the voice instances if it's an array
					if is_array(voice) {
						for (var i = 0; i < array_length(voice); ++i) {
							audio_stop_sound(voice[i])
						}
					}
				}
				
				// work on the pitch
				if is_array(struct_get(char_presets, char).voice_pitchrange){
					pitch = random_range(
						struct_get(char_presets, char).voice_pitchrange[0],
						struct_get(char_presets, char).voice_pitchrange[0]
					)
				}
				
				// play unless it's a punctuation sign
				if struct_get(char_presets, char).voice != -1 
					&& curchar != "." && curchar != " " 
					&& curchar != "," && curchar != "!" 
					&& curchar != "?" && curchar != "-" 
				{
					audio_play(__v,,,pitch,1)
				}
			}
			
			// create the character
			var inst = instance_create(o_text_single, x+xoff, y+yoff, depth)
			inst.symbol = curchar
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
			
			array_push(mychars, inst)
			disp_chars ++
			
			xoff += string_width(curchar) * xscale
			xoff += xspace * xscale
			text = string_delete(text, 0, 1)
			chars ++
			
			if auto_pauses { // automatic pause times based on the punctuation
				{ // en
					if (curchar == "." || curchar == "?" || curchar == "!")
					&& string_length(text) > 1 
					&& string_char_at(text, 1) == " "
						pause = 10
					
					if curchar == ","
						pause = 5
					
					if curchar == "-" 
					&& string_length(text) > 1 
					&& string_char_at(text, 1) == " "
						pause = 5
				}
				{ // ja
					if curchar=="…" || curchar=="？" || curchar=="。" || curchar=="・" || curchar=="！"
						pause = 10
					if curchar=="、" || curchar=="・" || curchar=="〜" || curchar=="～" || curchar=="゠"
						pause = 5
				}
			}
			
			// handle line breaks
			if array_contains(linebreaks, disp_chars) && auto_breaks {
				event_user(4)
			}
		}
	}
	// handle commands
	else if pause == 0 {
		looping = true
		
		var ccommand = ""
		ccommand = string_copy(text, 0, string_pos("}", text) - 1)
		
		// loop through to get all the arguments
		if string_contains("(", ccommand) {
			while string_char_at(text, 0) != "(" {
				command += string_char_at(text, 0)
				text = string_delete(text, 0, 1)
				
				chars ++
			}
			
			text = string_delete(text, 0, 1)
			chars ++
			
			while string_char_at(text, 0) != ")" {
				argstrings += string_char_at(text, 0)
				text = string_delete(text, 0, 1)
				
				chars ++
			}
		}
		// otherwise just collect it as is
		else {
			command = ccommand
			text = string_delete(text, 0, string_pos("}", text) - 1)
		}
		
		// loop until the end of the bracketed string
		while string_char_at(text, 0) != "}" {
			text = string_delete(text, 0, 1)
			chars ++
		}
	}
	
	// stop checking for commands if we've reached the closing bracket
	if string_char_at(text, 0) == "}" {
		command_mode = false
		text = string_delete(text, 0, 1)
		chars ++
		
		event_user(0)
		if string_char_at(text,0) != "{" || string_length(text) == 0
			looping = false
	}
		
	normalupd = false
}

// count down pauses
if pause > 0 {
	pause --
}

// -1 in pauses stands for "waiting for confirmation to resume"
// -2 in pauses stands for "waiting until pause variable is set to something else"
if pause == -1 || pause == -2 {
	skipping = false
	
	if instance_exists(npc_link) {
		if variable_instance_exists(npc_link, "s_talking")
			npc_link.s_talking = false
	}
	
	if instance_exists(caller) && pause != -2 {
		caller.can_proceed = true
	}
	if input_check_pressed("confirm") && pause != -2 {
		pause = 0
	}
}
else {
	if instance_exists(caller) {
		caller.can_proceed = false
		
		if instance_exists(npc_link) && !dont_update {
			if variable_instance_exists(npc_link, "s_talking") {
				npc_link.s_talking = true
			}
		}
	}
}
	
if _face == noone && instance_exists(face_inst) {
	instance_clean(face_inst)
	x -= 116
}
if face_expression != face_expression_prev {
	face_inst.facename = face_expression
	face_expression_prev = face_expression
}

if input_check_pressed("cancel") && skipping == false && can_skip{
	skipping = true
}

timer++