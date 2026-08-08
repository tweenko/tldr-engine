event_inherited();

fader_fade(1, 0, 0);
audio_play(snd_intro_noise);
audio_sound_gain(snd_intro_noise, 1);

x = GAME_W/2;
y = GAME_H/2;

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

__intro_init();

timer = 0;
surf = -1;