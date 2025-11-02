event_inherited()

trigger_code = function() {
	dodge_on()
}
trigger_exit_code = function() {
	dodge_off()
    triggered = false
}