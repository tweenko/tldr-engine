if on {
	if InputPressed(INPUT_VERB.UP) && array_length(choices) > 2
		selection = 2
	if InputPressed(INPUT_VERB.DOWN) && array_length(choices) > 3
		selection = 3
	if InputPressed(INPUT_VERB.LEFT) && array_length(choices) > 0
		selection = 0
	if InputPressed(INPUT_VERB.RIGHT) && array_length(choices) > 1
		selection = 1

	if InputPressed(INPUT_VERB.SELECT) && selection != -1
		instance_destroy()
}