msg = ""
msg_temp = ""
msg_time = 0

{ // theme
	white = c_white
	dark = #b39a9a
	shadow = c_black
	yellow = #ffff66
	outline_thickness = 4
	display_chapter = true
	bg = spr_ui_saveselect_door
}
{ // messages
	m_main = "Please select a file."

	m_copy = "Choose a file to copy."
	m_copyto = "Choose a file to copy to."
	m_copyempty = "It can't be copied."
	m_copycant = "You can't copy there."
	m_copysuccess = "Copy Complete."
	m_copy_overwritewarn = "The file will be overwritten."

	m_erase = "Choose a file to erase."
	m_erase_warn1 = "Choose a file to erase."
	m_erase_warn2 = "Choose a file to erase."
	m_erasesuccess = "Erase complete."
	m_eraseempty = "There's nothing to erase."
	
	m_chfile = "Start Chapter {0} from Chapter {1}'s FILE."
	m_chfileconfirm = "This will start Chapter {0} in FILE Slot {1}."
}

event_user(1)

files = []
files_prev = []

language = true
ch_file = (global.chapter>1)

soulx = 130
souly = 144
state = 0
stateprev = 0
selection = global.save_slot
selection_hor = 0
subselection = 0
buffer = 0
threat = 0

copy_from = 0
copy_to = 0

credit = $"{ENGINE_NAME} {ENGINE_VERSION}"

event_user(0)

prepared = 0
if files[0] != -1 { //check if its prepared
	var f = 1
	var a = [files[0].NAME, files[0].TIME]
	for (var i = 0; i < array_length(self.files); ++i) {
		if files[i] != -1 {
			if files[i].NAME == a[0] && files[i].TIME == a[1] {}
			else {
				f = 0; 
				break
			}
		}
		else {
			f=0; 
			break
		}
	}
	
	prepared = f
}

soul_put = function(xx, yy) {
	soulx = round( lerp(soulx, xx, .6) )
	souly = round( lerp(souly, yy, .6) )
}
option_draw = function(xx, yy, str, sel, selvar = selection) {
	draw_set_color(dark)
	if selvar == sel 
		draw_set_color(white)
	
	draw_text_transformed_shadow(xx, yy, str, 2, 2, 0, 2, shadow)
}
	
///@arg {string|function} str can also be callable, accepts the previous state as well
///@arg {real} time
msg_set = function(str, time = 120){
	if time > 0 {
		msg_temp = str
		msg_time = time
	}
	else {
		msg = str
		msg_time = 0
		msg_temp = ""
	}
	
	if is_callable(msg) 
		msg = msg(stateprev)
	msg = string(msg, global.chapter, global.chapter-1)
	
	if is_callable(msg_temp) 
		msg_temp = msg_temp(stateprev)
	msg_temp = string(msg_temp, global.chapter, global.chapter-1)
}
	
msg_set(m_main, 0)