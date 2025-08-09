///@arg {string, array<string>} dialogue
function encounter_scene_dialogue(dialogue, pre = "") {
	dialogue = dialogue_array_to_string(dialogue)
	
	cutscene_create()
	
	cutscene_set_variable(o_enc, "exec_wait", true)
	cutscene_dialogue("{yspace(14)}" + pre + dialogue)
	cutscene_set_variable(o_enc, "exec_wait", false)
	
	cutscene_play()
}