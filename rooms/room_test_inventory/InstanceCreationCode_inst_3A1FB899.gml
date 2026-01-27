name = "susieheal_use"

execute_code = function() {
    cutscene_create()
    
    if array_contains(global.party_names, "susie") {
        if item_spell_get_exists(item_s_susieheal, "susie") {
            cutscene_func(function() {
                var healcalc = item_spell_get_struct(item_s_susieheal, "susie").__heal_calc
                party_heal("susie", healcalc("susie"))
            })
            
            var __dialogue = ["* Susie used her healing on herself."]
            if item_spell_get_struct(item_s_susieheal, "susie")._data.progress == 0
                array_push(__dialogue, "* Perhaps if Susie's spell was somehow upgraded, something would change...")
            else 
            	array_push(__dialogue, "* Something about Susie's spell may have changed...!")
            
            cutscene_dialogue(__dialogue)
            cutscene_audio_play(snd_metalhit)
            
            cutscene_func(function() {
                if item_spell_get_exists(item_s_susieheal, "susie") {
                    var index = item_spell_get_index(item_s_susieheal, "susie")
                    var st = party_getdata("susie", "spells")[index]._data
                    
                    st.uses += 1
                    
                    party_getdata("susie", "spells")[index].__update_spell(st)
                }
            })
        }
        else {
            cutscene_dialogue([
                "* (Somehow, standing here, you realized something...)",
                "* (If {col(y)}SUSIE{reset_col} knew any {col(y)}healing spells{reset_col}, she could practice them here.)"
            ])
        }
    }
    else {
        cutscene_dialogue([
            "* (Somehow, standing here, you realized something...)",
            "* (If you had {col(y)}SUSIE{reset_col} in your party, she could do something here.)"
        ])
    }
    
	cutscene_play()
}