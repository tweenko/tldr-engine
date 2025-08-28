timer++

if state < 3 {
	if timer == 30 {
		state = 1
	}
	if timer == 31  
        sprite_delete(freezeframe)
	if timer == 50 {
		sprite_index = spr_soul_break
		audio_play(snd_break1)
	}
	if timer == 90 {
		audio_play(snd_break2)
		visible = false
	
		instance_create(o_eff_soulshard, x-2, y)
		instance_create(o_eff_soulshard, x, y+3)
		instance_create(o_eff_soulshard, x+2, y+6)
		instance_create(o_eff_soulshard, x+8, y)
		instance_create(o_eff_soulshard, x+10, y+3)
		instance_create(o_eff_soulshard, x+12, y+6)
	
		var a = image_blend
		with o_eff_soulshard 
			image_blend = a
	}
	if timer == 140 {
		instance_destroy(o_eff_soulshard)
	
		visible = true
		state = 2
	}
	if timer == 200 {
		music_play(mus_defeat, 0, true)
		state = 3
	}
		
	if timer < 200 {
		if InputPressed(INPUT_VERB.SELECT) 
            confirm_pressed++
		if confirm_pressed > 4 {
			event_user(0)
			exit
		}
	}
}

if state == 2 {
	if image_alpha < 1
	    image_alpha += .02
}
if state == 3 {
	if !dia_created{
		inst_dialogue = instance_create(o_text_typer, 100, 300, DEPTH_UI.DIALOGUE_UI, {
			text: "{can_skip(false)}{shadow(0)}{speed(3)}{xspace(3)}{yspace(18)}" + dialogue_array_to_string(dialogue) + "{p}{e}",
			gui: true,
			caller: id,
		})
		
		dia_created = true
	}
	else if !instance_exists(inst_dialogue){
		state = 4
	}
}
if state == 4 {
	if ui_alpha < 1
	    ui_alpha += .05
	
	if InputPressed(INPUT_VERB.LEFT) selection = 0
	else if InputPressed(INPUT_VERB.RIGHT) selection = 1
	
	if InputPressed(INPUT_VERB.SELECT) && ui_alpha > .5{
		timer = 0
		state = 5
	}
}
if state == 5 && selection == 0{
	if ui_alpha> 0 ui_alpha-=.05
	
	if timer == 1 {
		music_stop(0)
	}
	if timer == 30 {
		audio_play(snd_dtrans_lw)
	}
	if timer > 30 {
		fader_alpha += .03
	}
	
	if fader_alpha == 1.2 {
		event_user(0)
	}
}
if state == 5 && selection == 1 {
	if ui_alpha > 0 
        ui_alpha -= .05
	image_alpha = 0
	
	if timer == 1 {
		music_stop(0)
		inst_dialogue = instance_create(o_text_typer, 130, 160, depth, {
			text: "{preset(god_text)}{can_skip(false)}THEN THE WORLD{br}{s(20)}WAS COVERED{br}{s(20)}IN DARKNESS.{p}{e}",
			caller: id,
			gui: true
		})
	}
	if timer > 1 && !instance_exists(inst_dialogue){
		state = 6
		music_play(mus_darkness, 0, 0)
	}
}
if state == 6{
	if !music_isplaying(0){
		game_end()
	}
}

if selection == 0
	soulx = lerp(soulx, 160 + string_width(choice[0]), .4)
if selection == 1
	soulx = lerp(soulx, 380 + string_width(choice[1]), .4)