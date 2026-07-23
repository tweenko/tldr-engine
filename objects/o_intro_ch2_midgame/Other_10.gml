anim = false;

imgSpd = 1/3;

sprite_index = spr_intro_ch2_queen_rotate;
image_index = 0;
image_speed = 0;
image_alpha = 0;

x = 160;
y = 0;

cutscene_create();

cutscene_sleep(30);

cutscene_set_variable(self, "anim", true);
cutscene_animate(-150, 120, 15, anime_curve.back_out, self, "y");
cutscene_animate(0, 1, 10, anime_curve.linear, self, "image_alpha");
cutscene_sleep(20);

cutscene_set_variable(self, "sprite_index", spr_intro_ch2_queen);
cutscene_set_variable(self, "image_index", 0);
cutscene_sleep(30);

cutscene_set_variable(self, "sprite_index", spr_intro_ch2_queen_laugh);
cutscene_audio_play(snd_queen_bitcrushlaugh, false, 1.2);
cutscene_sleep(40);

cutscene_audio_play(snd_explosion_mmx3);
cutscene_set_variable(self, "sprite_index", spr_intro_ch2_queen_explode);
cutscene_set_variable(self, "image_index", 0);
cutscene_sleep(40);

cutscene_animate(1, 0, 10, anime_curve.linear, self, "image_alpha");
cutscene_sleep(30);

cutscene_func(room_goto, target_room);

cutscene_play();