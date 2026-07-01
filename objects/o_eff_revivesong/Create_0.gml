target_actor = noone;
target_member_name = "";
target_hp = 0;
target_heal = 0;

surf_light = -1;
surf_feathers = -1;

image_alpha = 0;

beam_rad = 0;
timer = 0;
cherub_draw = false;
cherub_index = 0;

timer_event_descent = 10;

cutscene_create();
cutscene_animate(0, 1, 6, anime_curve.linear, id, "image_alpha");
cutscene_animate(0, 1, 15, anime_curve.sine_in_out, id, "beam_rad");
cutscene_sleep(10);

cutscene_func(method(self, function() {
    audio_play(snd_sparkle_glock,,, 1.1);
    
    var _feather = instance_create(o_eff_revivesong_feather, x - 5, y - 100, depth - 10);
    _feather.direction = 270 + irandom_range(-30, -50);
    
    _feather = instance_create(o_eff_revivesong_feather, x, y - 100, depth - 10);
    _feather.direction = 270 + irandom_range(-10, 10);
    
    _feather = instance_create(o_eff_revivesong_feather, x + 5, y - 100, depth - 10);
    _feather.direction = 270 + irandom_range(30, 50);
}));
cutscene_sleep(25);

cutscene_set_variable(id, "cherub_draw", true);
cutscene_animate(0, 17, 30, anime_curve.linear, id, "cherub_index");
cutscene_sleep(30);

cutscene_set_variable(id, "cherub_draw", false);
cutscene_func(method(self, function() {
    if party_isup(target_member_name)
        party_heal(target_member_name, target_heal, o_enc);
    else 
        party_heal(target_member_name, target_hp - party_getdata(target_member_name, "hp"), o_enc);
}));
cutscene_animate(1, 0, 6, anime_curve.linear, id, "image_alpha");
cutscene_sleep(6);

cutscene_func(instance_destroy, [id])

cutscene_play();