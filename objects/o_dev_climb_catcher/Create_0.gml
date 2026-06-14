event_inherited();

trigger_code = function() {
    if !climb_check() 
        exit;
    
    o_dev_climb_controller.__climb_stop();
    
    cutscene_create();
    cutscene_player_canmove(false);
    
    cutscene_audio_play(snd_noise);
    cutscene_actor_override(get_leader(), true);
    cutscene_set_variable(get_leader(), "sprite_index", get_leader().s_landed);
    cutscene_animate(4, 0, 15, anime_curve.linear, get_leader(), "shake");
    cutscene_set_variable(o_camera, "target", noone);
    cutscene_func(camera_unpan, [get_leader(), 15]);
    cutscene_sleep(15);
    
    cutscene_set_variable(get_leader(), "s_dynamic", true);
    cutscene_actor_override(get_leader(), false);
    cutscene_set_variable(get_leader(), "dir", DIR.DOWN);
    
    cutscene_player_canmove(true);
    cutscene_play();
    
    triggered = false;
}