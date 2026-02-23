event_inherited()

interaction_code = function() {
    cutscene_create()
    
    cutscene_player_canmove(false)
    cutscene_dialogue([
        "* Swatch's Bake Sale! Buy the new exclusive item \"TensionGem\"!",
        "{money_display(`consumable`)}* It's just $99! Dirt Cheap, really!!",
        "{choice(`Buy`, `Don't Buy`)}"
    ], "{e}")
    cutscene_func(function() {
        if global.temp_choice == 0 {
            cutscene_create()
            
            if save_get("money") >= 99 {
                cutscene_dialogue([
                    "* (You put the money on top of the sign.)",
                    "* (Thoroughly reading the instructions at the bottom...)",
                    "* (You reached into a bag full of items behind the sign.)",
                    item_add(new ex_item_tesniongem())
                ],, false)
                cutscene_wait_dialogue_boxes(3)
                
                cutscene_audio_play(snd_noise)
                cutscene_wait_dialogue_finish()
                cutscene_player_canmove(true)
            }
            else {
                cutscene_dialogue([
                    "* (You don't have the money to buy it.)",
                    "* (...)",
                    "* (Nobody's watching.)",
                    "{choice(`Take`, `Leave`)}"
                ], "{e}")
                
                cutscene_func(function() {
                    if global.temp_choice == 0 {
                        cutscene_create()
                        
                        cutscene_audio_play(snd_noise)
                        cutscene_dialogue([
                            item_add(new ex_item_tesniongem())
                        ])
                        
                        cutscene_audio_play(snd_ominous)
                        
                        cutscene_player_canmove(true)
                        cutscene_play()
                    }
                    else {
                        cutscene_create()
                        cutscene_dialogue([
                            "* (Your throat felt like you swallowed a boulder.)",
                            "* (...in a good way.)",
                        ])
                        cutscene_player_canmove(true)
                        cutscene_play()
                    }
                })
            }
            
            cutscene_play()
        }
        else {
            cutscene_create()
            cutscene_player_canmove(true)
            cutscene_play()
        }
    })
    
    cutscene_play()
}