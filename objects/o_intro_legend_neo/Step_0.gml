if !active
    exit;

if !skipped && InputCheck(INPUT_VERB.SELECT) {
    skipped = true;
    
    cutscene_stop();
    
    cutscene_create();
    cutscene_func(fader_fade, [o_fader.image_alpha, 1, 30, DEPTH_UI.CONSOLE]);
    cutscene_func(music_fade, [0, 0, 30]);
    cutscene_sleep(40);
    
    cutscene_func(room_goto, [room_logo]);
    cutscene_play();
}