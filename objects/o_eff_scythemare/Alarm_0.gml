cutscene_create();

cutscene_audio_play(snd_impact);

cutscene_animate(0, 1, 4, anime_curve.linear, id, "image_alpha");
cutscene_animate(2, 1, 4, anime_curve.linear, id, "image_xscale");
cutscene_animate(2, 1, 4, anime_curve.linear, id, "image_yscale");
cutscene_sleep(7);

cutscene_set_variable(id, "trail", true);
cutscene_animate(0, -360 - 110, 20, anime_curve.sine_in_out, id, "image_angle");
cutscene_animate(0, 1, 20, anime_curve.linear, id, "z_alpha");
cutscene_sleep(6);

cutscene_func(function() {
    if !audio_is_playing(snd_spell_pacify)
        audio_play(snd_spell_pacify);
})
cutscene_sleep(9)

cutscene_animate(1, 0, 10, anime_curve.linear, id, "image_alpha");
cutscene_sleep(5);

cutscene_animate(-360 - 110, -360 - 90, 8, anime_curve.cubic_in, id, "image_angle");
cutscene_sleep(8);

cutscene_set_variable(id, "trail", false);
cutscene_animate(0, 3, 10, anime_curve.linear, id, "slash_image");
cutscene_func(method(self, function() {
    if success
        audio_play_sound_echo(snd_swing, 3, 0.34, 1, 1.5 + (target_enemy * 0.25));
    else 
        audio_play(snd_bump, 0, 1, 1 + random_range(-0.5, 0.5));
}));
if !success 
    cutscene_animate(5, 0, 10, anime_curve.linear, id, "shake");
cutscene_sleep(10);

if success {
    cutscene_animate(0, 10, 15, anime_curve.sine_out, id, "z_offset");
    cutscene_animate(1, 0, 15, anime_curve.linear, id, "z_alpha");
    cutscene_sleep(12);
    
    cutscene_spare_enemy(target_enemy);
}
else {
    cutscene_animate(y, y + 20, 15, anime_curve.linear, id, "y");
    cutscene_animate(-360 - 90, -360 - 90 - 30, 15, anime_curve.linear, id, "image_angle");
    cutscene_animate(1, 0, 15, anime_curve.linear, id, "z_alpha");
    cutscene_sleep(15);
}
cutscene_func(instance_destroy, [id]);

cutscene_play();