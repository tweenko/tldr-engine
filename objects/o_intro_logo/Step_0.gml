timer += 1;

if !active
    exit;

if state == 0 {
    siner += .5;
    factor -= (0.003/2 + siner/900);
    
    if factor < 0 {
        factor = 0;
        
        call_later(62, time_source_units_frames, method(o_intro_logo, function() {
            state = 2;
            siner = 0;
        }), false)
        
        state ++;
    }
}
else if state == 2 {
    siner += 0.5/2;
    
    phaseplus = (siner >= 20);
    
    if phaseplus {
        aa -= 0.02/2;
        ab -= 0.08/2;
    }
    
    factor2 += 0.05/2;
    
    if aa < -0.5 && !skipped 
        room_goto(target_room);
}

if InputPressed(INPUT_VERB.SELECT) && !skipped && timer > 5 {
    skipped = true;
    
    fader_fade(0, 1, 50);
    audio_sound_gain(snd_intro_noise, 0, 50*1000/30);
    
    cutscene_create();
    cutscene_sleep(60);
    
    cutscene_func(room_goto, target_room);
    cutscene_play();
}