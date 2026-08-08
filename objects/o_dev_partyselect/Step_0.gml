global.console = true

if keyboard_check_pressed(vk_right)
	selection ++
else if keyboard_check_pressed(vk_left)
	selection --

// cap selection
if selection < 0
	selection = 0
if selection > maxparty - 1 
	selection = maxparty - 1

xoff = lerp(xoff, selection, .4)

if keyboard_check_pressed(vk_enter) {
	audio_play(snd_metalhit)
	var name = struct_get_names(global.party)[selection]
	
	if !party_contains(name, true) {
		party_member_add(name)
        o_console.log_text($"{name} was added to your Party", c_orange);
    }
	else {
		party_member_kick(name)
        o_console.log_text($"{name} was removed from your Party", c_teal);
    }
}
if keyboard_check_pressed(vk_escape) {
	instance_destroy()
}