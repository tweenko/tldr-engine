if init 
	exit
	
draw_set_font(loc_font("main"))
if !encounter_mode 
	ui_dialoguebox_create(xx, yy, width, height)