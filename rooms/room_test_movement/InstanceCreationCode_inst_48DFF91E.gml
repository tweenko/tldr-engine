execute_code = function() {
    var currently_windy = (party_getdata(global.party_names[0], "s_state") == "wind");
    
    cutscene_create();
    cutscene_player_canmove(false);
    
    for (var i = 0; i < party_length(true); i ++) {
        cutscene_animate(0, 1, 4, anime_curve.linear, party_get_inst(global.party_names[i]), "flash");
        cutscene_sleep(2);
        cutscene_audio_play(snd_noise, 0, .5, .5 + i*.2);
    }
    
    cutscene_sleep(5);
    
    cutscene_audio_play(snd_climb_slip);
    cutscene_audio_play(snd_wing,,, 1.1);
    
    for (var i = 0; i < party_length(true); i ++) {
        cutscene_func(party_set_state, [global.party_names[i], (currently_windy ? "" : "wind")]);
        cutscene_func(method({inst: party_get_inst(global.party_names[i]), currently_windy}, function() {
            if !currently_windy {
                repeat(4) {
                    instance_create(o_eff_sparestar, inst.x + random_range(-10, 10), inst.s_get_middle_y() + random_range(-20, 20), inst.depth - 10, {image_blend: c_white, hspeed: 0, gravity: .1, image_xscale: .5, image_yscale: .5})
                }
                
                var aft = afterimage(.02, inst);
                aft.speed = .8;
                aft.dir = -90;
                
                aft = afterimage(.03, inst);
                aft.speed = 1.6;
                aft.dir = -90;
            }
            else {
                repeat(4) {
                    instance_create(o_eff_magicstar, inst.x + random_range(-10, 10), inst.s_get_middle_y() + random_range(-20, 20), inst.depth - 10, {image_blend: c_white})
                }
            }
        }))
        cutscene_animate(1, 0, 15, anime_curve.linear, party_get_inst(global.party_names[i]), "flash");
    }
    
    cutscene_sleep(15);
    
    cutscene_player_canmove(true);
    cutscene_play();
}