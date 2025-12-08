/// @description write
var normalupd = true

while looping || normalupd {
	var curchar = string_char_at(text, 0)
	
	// start checking for commands upon reaching a bracket
	if string_char_at(text, 0) == "{" {
		text = string_delete(text, 1, 1)
		command = ""
		command_mode = true
	}
	
	// type out the text
	if !command_mode {
		if init {
			event_user(1);
			init = false
		}
		if ((timer % typespd == 0) || skipping) && pause == 0 {
			draw_set_font(font)
			
			var __v = voice
			// choose the voice blip randomly if it's an array
			if is_array(voice)
				__v = array_shuffle(__v)[0]
            else if is_callable(voice)
                __v = voice(disp_chars)
            
			if audio_exists(__v) && !skipping && timer % voice_skip == 0 {
				var pitch = 1
				
				// stop the previous sounds if ordered to
				if struct_get(char_presets, char).voice_interrupt {
					audio_stop_sound(__v)
					
					// stop all the voice instances if it's an array
					if is_array(voice) {
						for (var i = 0; i < array_length(voice); ++i) {
							audio_stop_sound(voice[i])
						}
					}
				}
				
				// work on the pitch
                var __pitch_calc = struct_get(char_presets, char).voice_pitch_calc
                
                if !is_undefined(voice_pitchrange)
                    pitch = random_range(
						voice_pitchrange[0],
						voice_pitchrange[1]
					)
                else if is_real(__pitch_calc)
                    pitch = __pitch_calc
				else if is_callable(__pitch_calc)
					pitch = __pitch_calc()
                
				// play unless it's a punctuation sign
				if struct_get(char_presets, char).voice != -1 
					&& curchar != "." && curchar != " " && curchar != "　"
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
            inst.solid_color = solid_color
			
			array_push(mychars, inst) 
			disp_chars ++
			
			xoff += string_width(curchar) * xscale
			xoff += xspace * xscale
			text = string_delete(text, 1, 1)
			chars ++
			
			if auto_pauses { // automatic pause times based on the punctuation
				{ // en
					if (curchar == "." || curchar == "?" || curchar == "!")
					&& string_length(text) > 1 
					&& (string_char_at(text, 1) == " " || string_char_at(text, 1) == "　")
						pause = 10
					
					if curchar == ","
						pause = 5
					
					if curchar == "-" 
					&& string_length(text) > 1 
					&& (string_char_at(text, 1) == " " || string_char_at(text, 1) == "　")
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
			if array_contains(linebreaks, disp_chars) {
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
				text = string_delete(text, 1, 1)
				
				chars ++
			}
			
			text = string_delete(text, 1, 1)
			chars ++
			
			while string_char_at(text, 0) != ")" || command_string_mode {
                if string_char_at(text, 0) == "`" {
                    argstrings += string_char_at(text, 0)
                    command_string_mode = !command_string_mode
                    text = string_delete(text, 1, 1)
                    
                    chars ++
                }
                else {
    				argstrings += string_char_at(text, 0)
    				text = string_delete(text, 1, 1)
    				
    				chars ++
                }
			}
		}
		// otherwise just collect it as is
		else {
			command = ccommand
			text = string_delete(text, 1, string_pos("}", text) - 1)
		}
		
		// loop until the end of the bracketed string
		while string_char_at(text, 0) != "}" {
			text = string_delete(text, 1, 1)
			chars ++
		}
	}
	
	// stop checking for commands if we've reached the closing bracket
	if command_mode && string_char_at(text, 0) == "}" {
		command_mode = false
		text = string_delete(text, 1, 1)
		chars ++
		
		event_user(0)
		if string_char_at(text, 0) != "{" || string_length(text) == 0
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
    if pause == -2
        superskipping = false
    if !superskipping
	   skipping = false
	
	if instance_exists(npc_link) {
		if variable_instance_exists(npc_link, "s_talking")
			npc_link.s_talking = false
	}
	
	if instance_exists(caller) && pause != -2 {
		caller.can_proceed = true
	}
    
	if (InputPressed(INPUT_VERB.SELECT) || InputCheck(INPUT_VERB.SPECIAL)) && pause == -1 || (superskipping && superskipping_buffer == 0 && pause == -1) {
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
	x -= face_xoff
    face_xoff = 0
}
if face_expression != face_expression_prev {
	face_inst.f_index = face_expression
	face_expression_prev = face_expression
}

if (InputPressed(INPUT_VERB.CANCEL) || (timer == 0 && InputCheck(INPUT_VERB.CANCEL))) 
    && !skipping && can_skip && !command_mode && pause >= 0 
    && !superskipping && allow_skip_internal 
{
	skipping = true
    pause = 0
}

// refresh it every frame
superskipping = false
if InputCheck(INPUT_VERB.SPECIAL) && can_skip && !command_mode && allow_skip_internal && can_superskip {
    skipping = true
    superskipping = true
    
    if instance_exists(face_inst)
        face_inst.visible = true
    
    pause = 0
}