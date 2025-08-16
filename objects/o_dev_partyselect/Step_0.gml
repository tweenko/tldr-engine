global.console = true

if input_check_pressed("right") 
	selection++
else if input_check_pressed("left") 
	selection--

// cap selection
if selection < 0
	selection = 0
if selection > maxparty - 1 
	selection = maxparty - 1

xoff = lerp(xoff, selection, .4)

if input_check_pressed("confirm") {
	audio_play(snd_metalhit)
	var name = struct_get_names(global.party)[selection]
	
	var lx = get_leader().x
	var ly = get_leader().y
	
	if party_getpos(name) == -1 {
		array_push(global.party_names, name)
		party_member_create(name)
		party_reposition(lx, ly)
	}
	else{
		instance_destroy(party_getobj(name))
		array_delete(global.party_names, party_getpos(name), 1)
		party_reposition(lx, ly)
	}
}
if input_check_pressed("cancel") {
	instance_destroy()
}