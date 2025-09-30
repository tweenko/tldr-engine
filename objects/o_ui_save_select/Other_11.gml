/// @description theme set
var theme = ""
// theme = "ominous"
theme = "finished"

if theme == "ominous"{
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
		m_main = function(prev){
			return ""
		}

		m_copy = function(prev){
			if prev == 22 
				return "IT RETAINED ITS ORIGINAL SHAPE."
			return "CHOOSE THE ONE TO COPY."
		}
		m_copyto = function(prev){
			if prev == 22 
				return "IT RETAINED ITS ORIGINAL SHAPE."
			return "CHOOSE THE TARGET FOR THE REFLECTION."
		}
		m_copyempty = function() {
			var f = 1
			for (var i = 0; i < array_length(self.files); ++i) {
				if self.files[i] != -1 
					f=0
			}
			
			if f 
				return "BUT THERE WAS NOTHING LEFT TO COPY."
			return "IT IS BARREN AND CANNOT BE COPIED."
		}
		m_copycant = "IT IS IMMUNE TO ITS OWN IMAGE."
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
						return "WHAT AN INTERESTING BEHAVIOR."
					if f 
						return "PREPARATIONS ARE COMPLETE."
				}
			}
			if prev == 22 && state == 0
				return "IT CONFORMED TO THE REFLECTION."
			return "THE DIVISION IS COMPLETE."
		}
		m_copy_overwritewarn = "IT WILL BE SUBSUMED."

		m_erase = function(prev) {
			if prev == 32 || prev == 31 {
				if threat >= 10 {
					threat = 0
					return "VERY INTERESTING."
				}
				else {
					return "THEN IT WAS SPARED."
				}
			}
			return "SELECT THE ONE TO ERASE."
		}
		m_erase_warn1 = "TRULY ERASE IT?"
		m_erase_warn2 = "THEN IT WILL BE DESTROYED."
		m_erasesuccess = "IT WAS AS IF IT WAS NEVER THERE AT ALL."
		m_eraseempty = function() {
			var f = 1
			for (var i = 0; i < array_length(self.files); ++i) {
				if self.files[i] != -1 
					f = 0
			}
			if f 
				return "BUT THERE WAS NOTHING LEFT TO ERASE."
			return "BUT IT WAS ALREADY GONE."
		}
	
		m_chfile = "Start Chapter {0} from Chapter {1}'s FILE."
		m_chfileconfirm = "This will start Chapter {0} in FILE Slot {1}."
	}
	
	music_play(mus_drone,0)
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
	
	music_play(mus_story,0)
}
else {
	music_play(mus_menu,0)
}
	
fader_fade(1, 0, 15)