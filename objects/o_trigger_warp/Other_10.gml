/// @description Trigger Entered
triggered = true
trigger_exit = true //always leave in
savedir = get_leader().dir

if audio_exists(enter_sound)
    audio_play(enter_sound)

fader_fade(0, 1, 7)

alarm[0] = 8
get_leader().moveable = false