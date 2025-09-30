global.console = true

if InputPressed(INPUT_VERB.RIGHT) 
	selection++
else if InputPressed(INPUT_VERB.LEFT) 
	selection--

// cap selection
if selection < 0
	selection = 0
if selection > maxparty - 1 
	selection = maxparty - 1

xoff = lerp(xoff, selection, .4)

if InputPressed(INPUT_VERB.SELECT) {
	audio_play(snd_metalhit)
	var name = struct_get_names(global.party)[selection]
	
	var lx = get_leader().x
	var ly = get_leader().y
	
	if party_getpos(name) == -1 {
		array_push(global.party_names, name)
		party_member_create(name)
		party_reposition(lx, ly)
	}
	else {
		instance_destroy(party_get_inst(name))
		array_delete(global.party_names, party_getpos(name), 1)
		party_reposition(lx, ly)
        
        with get_leader() {
            is_player = true
            is_follower = false
        	event_user(2)
        }
	}
}
if InputPressed(INPUT_VERB.CANCEL) {
	instance_destroy()
}