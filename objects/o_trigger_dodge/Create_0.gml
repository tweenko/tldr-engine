event_inherited()

trigger_code = function() {
	get_leader().dodge_mode = true
}
trigger_exit_code = function() {
	get_leader().dodge_mode = false
    triggered = false
}