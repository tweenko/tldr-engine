event_inherited()
interaction_code = function() {
	if !climb_get_enabled() {
		dialogue_start(loc("txt_climb_noclaws"));
		return false;
	}
	
	climb_start_nearest();
}