trigger_code = function() {
    get_leader().under_lighting = true
}
trigger_exit_code = function() {
    get_leader().under_lighting = false
    triggered = false
}