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
    
    animate(character.x, xreq[step], time[step], anime_curve.linear, character, "x")
    animate(character.y, yreq[step], time[step], anime_curve.linear, character, "y")
    
    var a = animate(0, -30, floor(time[step]/2), anime_curve.cubic_out, character, "yoff", false)
        a._add(0, floor(time[step]/2), anime_curve.cubic_in)
        a._start()
    
	
	var spr = character.s_ball
	if sprite_exists(spr) {
		character.sprite_index = spr
		character.image_speed = 1
	}
	character.s_override = true
	
	state = 0
	timer = 0
}