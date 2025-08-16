if on {
	if input_check_pressed("up") && array_length(choices) > 2
		selection = 2
	if input_check_pressed("down") && array_length(choices) > 3
		selection = 3
	if input_check_pressed("left") && array_length(choices) > 0
		selection = 0
	if input_check_pressed("right") && array_length(choices) > 1
		selection = 1

	if input_check_pressed("confirm") && selection != -1
		instance_destroy()
}