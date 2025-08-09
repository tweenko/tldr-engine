/// @description Trigger Entered
triggered = true
trigger_exit = true //always leave in
savedir = get_leader().dir

do_anime(0, 1, 8, "linear", function(v) {
	if instance_exists(o_fader) o_fader.image_alpha=v
})

alarm[0] = 8
get_leader().moveable = false