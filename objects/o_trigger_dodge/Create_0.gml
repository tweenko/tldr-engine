event_inherited()

trigger_code = function() {
	dodge_on()
}
trigger_exit_code = function() {
    var can_turn_off = true;
    with o_trigger_dodge {
        if id != other.id && triggered {
            can_turn_off = false;
            break;
        }
    }
    triggered = false;
    
    if can_turn_off {
   	    dodge_off()
    }
}