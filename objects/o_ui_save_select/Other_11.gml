/// @description theme set
var theme = ""
//theme = "ominous"
theme = "finished"

loc_id_messages = "save_select_messages_normal"

if theme == "ominous" {
	{ // theme
		white = #07FF00
		dark = #008000
		shadow = c_black
		yellow = #7BEE84
		outline_thickness = 2
		display_chapter = false
		bg = -1
	}
	{ // messages
		m_main = "main"

		m_copy = function(prev){
			if prev == 22 
				return "copy_returned"
			return "copy"
		}
		m_copyto = function(prev){
			if prev == 22 
				return "copy_returned"
			return "copyto"
		}
		m_copyempty = function() {
			var f = 1
			for (var i = 0; i < array_length(self.files); ++i) {
				if self.files[i] != -1 
					f = 0
			}
			
			if f 
				return "copyempty_all"
			return "copyempty"
		}
		m_copycant = "copycant"
		m_copysuccess = function(prev) {
			if (prev == 22 || prev == 21) && state == 0 {
				if files[0] != -1 {
					var p = prepared
					var f = 1
					var a = [files[0].NAME, files[0].TIME]
					for (var i = 0; i < array_length(self.files); ++i) {
						if self.files[i] != -1 {
							if files[i].NAME == a[0] && files[i].TIME == a[1] {}
							else 
								f = 0
						}
					}
					
					prepared = f
					if p && f 
						return "copysuccess_weird"
					if f 
						return "copysuccess_prepared"
				}
			}
			if prev == 22 && state == 0
				return "copysuccess_conformed"
			return "copysuccess"
		}
		m_copy_overwritewarn = "overwritewarn"

		m_erase = function(prev) {
			if prev == 32 || prev == 31 {
				if threat >= 10 {
					threat = 0
					return "erase_interesting"
				}
				else {
					return "erase_cancel"
				}
			}
			return "erase"
		}
		m_erase_warn1 = "erase_warn1"
		m_erase_warn2 = "erase_warn2"
		m_erasesuccess = "erasesuccess"
		m_eraseempty = function() {
			var f = 1
			for (var i = 0; i < array_length(self.files); ++i) {
				if self.files[i] != -1 
					f = 0
			}
			if f 
				return "eraseempty_all"
			return "eraseempty"
		}
	
		m_chfile = "chfile"
		m_chfileconfirm = "chfileconfirm"

        loc_id_messages = "save_select_messages_ominous"
	}
	
	target_music = mus_drone
}
else if theme == "finished" {
	{ // theme
		white = c_white
		dark = #9a9ab3
		shadow = c_black
		yellow = #ffff66
		outline_thickness = 4
		bg = spr_ui_saveselect_fountain
		image_alpha = 0
	}
	
	target_music = mus_story
}
else {
	target_music = mus_menu
}
	
fader_fade(1, 0, 15)

// load localization
event_user(2)