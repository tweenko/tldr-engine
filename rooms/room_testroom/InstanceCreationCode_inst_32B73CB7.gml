execute_func = function() {
	//cutscene_create()
	//cutscene_player_canmove(false)
	//cutscene_party_follow(false)
	//
	//for (var i = 0; i < array_length(global.party_names); ++i) {
	    //cutscene_actor_move(party_getobj(global.party_names[i]), [
            //new __actor_movement_jump(room_width/2 - (array_length(global.party_names)-1) * 15 + i*30, 140),
		//], i, false)
	//}
	//cutscene_wait_until(function() {
        //return !instance_exists(o_actor_mover)
    //})
	//
	//cutscene_player_canmove(true)
	//
	//cutscene_party_follow(true)
	//cutscene_party_interpolate()
	//cutscene_play()
    
    
    cutscene_create()
    cutscene_func(function() {
        var h = party_getdata("susie", "spells")[item_spell_get_index(item_s_susieheal, "susie")]._heal_calc
        party_heal("susie", h("susie"))
    })
    cutscene_dialogue("* Susie used her healing on herself. {p}{c}* Something may have changed about her spell...")
    cutscene_audio_play(snd_metalhit)
    
    cutscene_func(function() {
        if item_spell_get_exists(item_s_susieheal, "susie") {
            var i = item_spell_get_index(item_s_susieheal, "susie")
            var st = party_getdata("susie", "spells")[i]._data
            
            st.uses += 1
            
            party_getdata("susie", "spells")[i].__update_spell(st)
        }
    })
	cutscene_play()
}