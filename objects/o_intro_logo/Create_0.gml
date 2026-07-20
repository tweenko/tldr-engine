event_inherited();

__init = function() {
	fader_fade(1, 0, 1);
	music_play(snd_intro_noise, 0, false);
	
	x = 160;
	y = 120;
	
	show_chapter = true;
	
	siner = 0;
	factor = 1;
	factor2 = 0;

	aa = 1;
	ab = 1;
	phaseplus = false;

	active = false;
	state = 0;

	skipped = false;
}

__init();
game_set_speed(15, gamespeed_fps);

__intro_init();