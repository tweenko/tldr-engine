event_inherited();
state = false;

interaction_code = function() {
    if !state {
        state = true;
        memory_set("switches", id, true);
        audio_play(snd_noise);
        instance_activate_layer("inst_climb_reveal");
        image_blend = c_gray;
        image_index = 1;
        
        cutscene_create();
        cutscene_player_canmove(false);
        cutscene_sleep(10);
        
        cutscene_audio_play(snd_shadowpendant,,, 1.2);
        cutscene_audio_play(snd_crow,,, .6);
        cutscene_audio_play(snd_impact);
        
        cutscene_func(screen_shake, [4]);
        cutscene_func(function() {
            layer_set_visible("tile_reveal", true);
        });
        cutscene_sleep(10);
        
        cutscene_player_canmove(true);
        cutscene_play();
    }
};