global.console = true

if input_check_pressed_repeat("up") {
	if selection > 0 {
		selection--
	}
}

if input_check_pressed_repeat("down"){
	if selection < array_length(encounters) - 1 {
		selection++
	}
}

if input_check_pressed("confirm") {
	instance_destroy()
	enc_start(encounters[selection])
}

if input_check_pressed("cancel") {
	instance_destroy()
}