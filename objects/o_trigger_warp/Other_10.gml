/// @description Trigger Entered
triggered = true;
trigger_exit = true; //always leave in
savedir = get_leader().dir;
was_climbing = climb_check();

if audio_exists(enter_sound)
    audio_play(enter_sound);

fader_fade(0, 1, 7);

if !(global.platforming_perspective > 0)
	get_leader().moveable = false;

alarm[0] = 8;
