name = "susieheal_upgrade"

execute_code = function() {
    cutscene_create()
    
    if array_contains(global.party_names, "susie") {
        if item_spell_get_exists(item_s_susieheal, "susie") {
            if item_spell_get_exists(item_s_susieheal, "susie") {
                var _item = item_spell_get_struct(item_s_susieheal, "susie")
                var datastruct = _item._data
                datastruct.progress += 1
                datastruct.progress = clamp(datastruct.progress, 0, 3)
                
                _item.__update_spell(datastruct)
            }
            
            var spell = item_spell_get_struct(item_s_susieheal, "susie")
            if spell._data.progress < 4 {
                cutscene_dialogue([
                    "* Susie trained long and hard, and has upgraded her healing...",
                    string("* Susie's healing has evolved, and is now called {0}!", item_get_name(spell))
                ])
                cutscene_audio_play(snd_metalhit)
            }
            else {
                cutscene_dialogue([
                    "* Susie trained long and hard, however...",
                    "* It seems like Susie has reached her true potential."
                ])
            }
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