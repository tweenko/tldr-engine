if on {
	if input_check_pressed("up") 
		selection = 2
	if input_check_pressed("down") 
		selection = 3
	if input_check_pressed("left") 
		selection = 0
	if input_check_pressed("right") 
		selection = 1

	if input_check_pressed("confirm") && selection != -1
		instance_destroy()
}