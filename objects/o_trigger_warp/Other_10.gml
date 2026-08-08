/// @description Trigger Entered
event_inherited();

savedir = get_leader().dir;
was_climbing = climb_check();

if audio_exists(enter_sound)
    audio_play(enter_sound);

fader_fade(0, 1, 7);

alarm[0] = 8;
get_leader().moveable = false;