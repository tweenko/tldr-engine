name = "choice test"

execute_code = function() {
    var evil = state_get("test_sad", 1)
    
	cutscene_create()
    cutscene_player_canmove(false)
    
    if !evil {
    	cutscene_dialogue("* Hello! This is a test of the Choice thing.{p}{c}* Is it cool?{p}{c}{choice(`Hell Yeah,d`, `I like it`, `Peak`, `Uhh`)}{e}", "")
    	
    	cutscene_func(function() {
    		if global.temp_choice == 3 {
                cutscene_create()
                cutscene_player_canmove(false)
    			cutscene_dialogue("* Huh? What do you mean... \"Uhh\"?{p}{c}{choice(`Sorry, I Meant\nit's Cool`, `I mean...`)}", "{e}")
                
                cutscene_func(function() {
            		if global.temp_choice == 1 {
                        cutscene_create()
                        cutscene_player_canmove(false)
            			cutscene_dialogue("* What is it? I-Is it good? Hey?{p}{c}{choice(`Haha! That's\na joke`, `It Sucks.`)}", "{e}")
                        
                        cutscene_func(function() {
                    		if global.temp_choice == 1 {
                                cutscene_create()
                                cutscene_player_canmove(false)
                                
                    			cutscene_dialogue("* ...{p}{c}* I'm sorry.")
                                cutscene_audio_play(snd_ominous)
                                
                                cutscene_func(function() {
                                    state_add("test_sad", 1)
                                })
                                
                                cutscene_player_canmove(true)
                                cutscene_play()
                                
                                return -1
                    		}
                            
                    		dialogue_start("* Haha! Okay then.")
                    	})
                        cutscene_wait_until(function() { 
                    		return !instance_exists(o_ui_dialogue) 
                    	})
                        cutscene_player_canmove(true)
                        
                        cutscene_play()
                        
                        return -1
            		}
            		dialogue_start("* Thanks!")
            	})
                
                cutscene_wait_until(function() { 
                    return !instance_exists(o_ui_dialogue) 
                })
                cutscene_player_canmove(true)
                
                cutscene_play()
                
                return -1
    		}
            
    		dialogue_start("* Thanks!")
    	})
    	cutscene_wait_until(function() { 
    		return !instance_exists(o_ui_dialogue) 
    	})
    }
    else {
    	cutscene_dialogue("* H-Hello again...{p}{c}* ...")
    }
    
	cutscene_player_canmove(true)
	cutscene_play()
}