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
	
	if !party_ismember(name)
		party_member_add(name)
	else
		party_member_kick(name)
}
if InputPressed(INPUT_VERB.CANCEL) {
	instance_destroy()
}