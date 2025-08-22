alarm[0] = 1

can_proceed = false
die = false
text = ""

width = 577
height = 151
xx = 32
yy = 320

depth = DEPTH_UI.DIALOGUE_UI

encounter_mode = false
init = true
postfix = "{p}{e}"
prefix = ""
textinst = noone

die_delay = 1

if instance_exists(get_leader()) 
	get_leader().moveable_dialogue = false

_reposition_self = function() {
	if instance_exists(get_leader()) {
        yy = 320
		if get_leader().y - guipos_y() > 160
			yy = 10
	}
}
_reposition_self_to = function(down) {
	if down
        yy = 320
    else
    	yy = 10
}
_reposition_self()