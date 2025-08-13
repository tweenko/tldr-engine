execute_func = function() {
	//cutscene_create()
	//cutscene_player_canmove(false)
	//cutscene_party_follow(false)
    //
	//cutscene_actor_move(o_actor_kris, [
		//new __actor_movement_jump(200, 140),
		//new __actor_movement(200, 200, 100,,,DIR.LEFT),
		//new __actor_movement_jump(o_actor_kris.x, o_actor_kris.y),
	//])
    //
	//cutscene_wait_until(function(){
        //return !instance_exists(o_actor_mover)
    //})
    //
	//cutscene_player_canmove(true)
	//cutscene_party_follow(true)
	//cutscene_party_interpolate()
    //
	//cutscene_play()
    
    cutscene_create()
    cutscene_dialogue("* Susie trained long and hard, and has upgraded her healing!")
    cutscene_audio_play(snd_metalhit)
    cutscene_func(function() {
        if item_spell_get_exists(item_s_susieheal, "susie") {
            var i = item_spell_get_index(item_s_susieheal, "susie")
            var st = party_getdata("susie", "spells")[i]._data
            
            st.progress += 1
            
            party_getdata("susie", "spells")[i].__update_spell(st)
        }
    })
	cutscene_play()
}