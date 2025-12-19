if on {
	if InputPressed(INPUT_VERB.UP) && array_length(choices) > 2
		selection = 2
	if InputPressed(INPUT_VERB.DOWN) && array_length(choices) > 3
		selection = 3
	if InputPressed(INPUT_VERB.LEFT) && array_length(choices) > 0
    {
        if cant_left = 0
        {
        selection = 0
        }
        else {
        	audio_play(snd_hurt)
            shake = -5
        }
    }
	if InputPressed(INPUT_VERB.RIGHT) && array_length(choices) > 1
    {
		if cant_right = 0
        {
        selection = 1
        }
        else {
        	audio_play(snd_hurt)
            shake = 5
        }
    }

	if InputPressed(INPUT_VERB.SELECT) && selection != -1
		instance_destroy()
}

if shake > 0
{
    shake_x = random_range(0,shake)
    shake --
}
else if shake < 0{
	shake_x = random_range(shake,0)
    shake ++
}
else {
	shake_x = 0
}