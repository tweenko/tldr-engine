/// @description calculate new data
if !instance_exists(character) {
	instance_destroy();
	show_debug_message("actor_mover: actor not found")
	
	exit
}

array_set(global.charmove_insts, pos, id)

if seed[step] == "" {
	xdiff = xreq[step] - character.x
	ydiff = yreq[step] - character.y
	character.moveable_move = false
	
	var dist = point_distance(0, 0, xdiff, ydiff)
	if time[step] == undefined
		time[step] = dist/spd[step]
    else
        spd[step] = dist/time[step] * 2
		
	time[step] = max(1, time[step])
}
else if seed[step] == "jump" {
	var dist = point_distance(0, 0, xdiff, ydiff)
	
	time[step] = 15
	time[step] = max(1, time[step])
	
	audio_play(snd_jump,,,, 1)
	
	var xxdiff = xreq[step] - character.x
	var yydiff = yreq[step] - character.y
	do_anime(character.x, character.x + xxdiff, time[step], "linear", function(v) {
		if instance_exists(character) 
			character.x = v
	})
	do_anime(character.y, character.y + yydiff, time[step], "linear", function(v) {
		if instance_exists(character) 
			character.y = v
	})
	
	var a = create_anime(0)
		.add(-30, floor(time[step]/2), "cubic_out")
		.add(0, floor(time[step]/2), "cubic_in")
		.start(function(v) {
			if instance_exists(character)
				character.yoff = v
		})
	
	var spr = character.s_ball
	if sprite_exists(spr) {
		character.sprite_index = spr
		character.image_speed = 1
	}
	character.s_override = true
	
	state = 0
	timer = 0
}