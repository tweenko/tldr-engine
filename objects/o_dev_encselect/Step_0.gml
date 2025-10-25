global.console = true

if InputRepeat(INPUT_VERB.UP) {
	if selection > 0 {
		selection--
	}
}

if InputRepeat(INPUT_VERB.DOWN){
	if selection < array_length(encounters) - 1 {
		selection++
	}
}

if InputPressed(INPUT_VERB.SELECT) {
	instance_destroy()
	new encounters[selection]()._start()
}

if InputPressed(INPUT_VERB.CANCEL) {
	instance_destroy()
}