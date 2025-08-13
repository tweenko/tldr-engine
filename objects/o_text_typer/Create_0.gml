{ // configuration
	text = ""
	font = loc_getfont("text")
	gui = false
	destroy_caller = false
	
	xspace = 0
	yspace = 18
	
	char = "none"
	shadow = true
	
	typespd = 1
	
	xscale = 2
	yscale = 2
	maxw = 0
	maxh = 0
	center_x = false
	center_y = false
	
	npc_link = noone
	xcolor = c_white
	effect = 0
	god = 0
	
	can_skip = true
}
{ // face & voice
	_face = 0
	face_inst = noone
	face_expression = 0
	face_expression_prev = 0
	
	voice = snd_text
	voice_pitchrange = 0
	voice_interrupt = 0
	voice_skip = 1
	
	chartimeroff = -2
}
{ // functionality variables
	caller = 0
	init = true
	
	skipping = false
	superskipping = false
	
	chars = 0
	disp_chars = 0 //displayed characters
	mychars = []
	linebreaks = []
	dont_update = false
	saved_color = c_white
	
	curchar = ""
	xoff = 0
	yoff = 0
    center_xoff = 0
    center_yoff = 0
	
	timer = 0
	pause = 0
	
	command_mode = false
	command = ""
	argstrings = ""
	
	choice_inst = noone
	looping = false
	break_tabulation = 0
	current_box = 0
	
	auto_pauses = true
	auto_breaks = true
	
	_facechange = function(char, expression = "neutral", change_delay = 4) {
		_face = struct_get(struct_get(char_presets, char), "_face")
		if instance_exists(face_inst) {
			x -= 116
			instance_destroy(face_inst)
		}
		if object_exists(_face) {
			face_expression = expression
			face_inst = instance_create(_face, x, y, depth - 100)
			face_inst.facename = face_expression
			face_inst.caller = id
			face_inst.alarm[0] = change_delay
            
            x += 116
		}
		
		pause += change_delay
	}
}

char_presets = {
	none: {
		_face: noone,
		voice: snd_text,
		voice_pitchrange: 0,
		voice_interrupt: false,
		voice_skip: 1,
	},
	susie: {
		_face: o_face_susie,
		voice: snd_text_susie,
		voice_pitchrange: 0,
		voice_interrupt: false,
		voice_skip: 1,
	},
	susie_bangs: {
		_face: o_face_susie_bangs,
		voice: snd_text_susie,
		voice_pitchrange: 0,
		voice_interrupt: false,
		voice_skip: 1,
	},
	ralsei: {
		_face: o_face_ralsei,
		voice: snd_text_ralsei,
		voice_pitchrange: 0,
		voice_interrupt: false,
		voice_skip: 1,
	},
	ralsei_hat: {
		_face: o_face_ralsei_hat,
		voice: snd_text_ralsei,
		voice_pitchrange: 0,
		voice_interrupt: false,
		voice_skip: 1,
	},
	noelle: {
		_face: o_face_noelle,
		voice: snd_text_noelle,
		voice_pitchrange: 0,
		voice_interrupt: false,
		voice_skip: 1,
	},
}