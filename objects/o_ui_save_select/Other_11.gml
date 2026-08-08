/// @description theme set
var completed = save_is_chapter_completed();
var slots = save_read_all(global.chapter)

var theme = completed ? global.registered_chapters[global.chapter-1].save_theme_completed : global.registered_chapters[global.chapter-1].save_theme_default;

loc_id_messages = "save_select_messages_normal"

if theme == SAVE_SELECT_THEME.OMINOUS {
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
				if files[0] != -1 { // check if all saves are identical (very specific secret in DR)
                	var prepared_previous = prepared;
                    
                    prepared = true;
                	var reference_save = [files[0].NAME, files[0].TIME];
                	for (var i = 0; i < array_length(files); ++i) {
                		if is_struct(files[i]) || (files[i].NAME == reference_save[0] && files[i].TIME == reference_save[1]) {
                			prepared = false; 
                			break;
                		}
                	}
                    
					if prepared_previous && prepared
						return "copysuccess_weird"
					else if prepared
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
else if theme == SAVE_SELECT_THEME.FOUNTAIN {
	{ // theme
		white = c_white
		dark = #9a9ab3
		shadow = c_black
		yellow = #ffff66
		outline_thickness = 4
		bg = spr_ui_saveselect_fountain;
		image_alpha = 0
	}
	
	target_music = mus_story;
	target_music_pitch = 0.95;
}
else {
	target_music = mus_menu;
	target_music_pitch = 0.95;
}
	
fader_fade(1, 0, 15)

// load localization
event_user(2)