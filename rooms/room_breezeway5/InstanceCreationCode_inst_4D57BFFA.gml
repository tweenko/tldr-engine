trigger_code = function() {
    cutscene_create()
	
    cutscene_player_canmove(false)
	
    cutscene_party_follow(false)
    cutscene_func(music_pause, 0) 
    
  
    cutscene_sleep(20)
    cutscene_audio_play(snd_spawn_weaker)
    cutscene_sleep(30)
    
    cutscene_set_variable(party_get_inst("susie"), "sprite_index", spr_susie_shock)
    cutscene_dialogue([
        "{char(susie, 6)}* Wait... did you guys hear that?"
    ],, false, false)
    cutscene_wait_dialogue_finish()
    

    cutscene_sleep(20)
    cutscene_audio_play(snd_spawn_weaker)
    cutscene_sleep(40)
    cutscene_audio_play(snd_spawn_weaker)
    cutscene_sleep(30)
    

    cutscene_dialogue([
        "{char(ralsei, 43)}* U-um... Reggie?  [placeholder]?",
        "{char(ralsei, 43)}* SOMETHINGS FOLLOWING US!."
    ],, false, false)
    cutscene_wait_dialogue_finish()
    
    cutscene_func(function() {

      audio_play(mus_chasealt)


        var leader = get_leader()
        instance_create_depth(leader.x - 50 , leader.y - 50, leader.depth, o_bullet_dentos_chase)
    })
    
    cutscene_party_follow(true)
    cutscene_player_canmove(true)
    cutscene_play()
}