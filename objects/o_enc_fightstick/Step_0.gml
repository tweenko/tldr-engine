if die {
	image_alpha-=.2
	
	if image_alpha <= 0 
		instance_destroy()
	x -= 6
	
	exit
}

if fading {
	image_alpha -= .1
	image_xscale += .1
	image_yscale += .1
	if image_alpha <= 0 
		instance_destroy()
}
else if !fading {
	if order == caller.order && !fading {
	    if InputPressed(INPUT_VERB.SELECT) && !caller.buffer && x > 60 {
			if x < 79+125 {
				if x > 84 && x < 90 {
					perfect = true
					image_blend = c_yellow
				}
				
		        with (o_enc_fightstick) {
		            if order == caller.order && !fading{
						if x > 84 && x < 90 {
							perfect = true 
							image_blend = c_yellow
						}
						
		                fading = true
						event_user(1)
		            }
		        }
				
				event_user(0)
				
				caller.lightup = 1
				caller.buffer = 1
				
				event_user(1)
				
				audio_play(snd_attack)
				if perfect
					audio_play(snd_criticalswing)
				
				exit
			}
			else
				caller.lightup = 1
	    }
	}
	if x < 60 {
		die = true
		event_user(0)
	}
	if life % 2 == 0 
		afterimage(,,1)
	x -= 7
	
	life ++
}