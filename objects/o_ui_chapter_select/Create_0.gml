chapters = [
	{
		name: loc("chapter_1"),
		exec: function(caller) {
			music_stop(0)
			audio_play(snd_ui_scary)
			
			animate(0, 1, 20, "linear", caller, "trans_shrink")
			
			call_later(80, time_source_units_frames, function() {
				global.chapter = 1
                
                global.save.ROOM = room_ex_dforest
                global.save.CHAPTER = 1
				
				save_reload()
				room_goto(room_save_select)
			})
		},
		icon: spr_ui_chs_ch1,
	},
	{
		name: loc("chapter_2"),
		exec: function(caller){
			music_stop(0)
			audio_play(snd_chs_ch2)
			
			animate(0, 1, 20, "linear", caller, "trans_shrink")
			
			call_later(80, time_source_units_frames, function() {
				global.chapter = 2
                
				global.save.ROOM = room_ex_city
                global.save.CHAPTER = 2
				
				save_reload()
				room_goto(room_save_select)
			})
		},
		icon: spr_ui_chs_ch2,
	},
	{
		name: loc("chapter_3"),
		exec: function(caller){
			music_stop(0)
			audio_play(snd_chs_ch3)
			
			animate(0, 1, 20, "linear", caller, "trans_shrink")
			
			call_later(80, time_source_units_frames, function() {
				global.chapter = 3
                
				global.save.ROOM = room_test_main
                global.save.CHAPTER = 3
				
				save_reload()
				room_goto(room_save_select)
			})
		},
		icon: spr_ui_chs_ch3,
	},
	{
		name: loc("chapter_4"),
		exec: function(caller){
			music_stop(0)
			audio_play(snd_chs_ch4)
			
			animate(0, 1, 20, "linear", caller, "trans_shrink")
			
			call_later(80, time_source_units_frames, function() {
				global.chapter = 4
                
				global.save.ROOM = room_ex_church
                global.save.CHAPTER = 4
				
				save_reload()
				room_goto(room_save_select)
			})
		},
		icon: spr_ui_chs_ch4,
	},
	-1,
	-1,
	-1,
]

yadd = -80
alpha = 0
selection = global.chapter
horselection = 0
sselection = 0
confirming = false
confirmselection = 0
vtext_alpha = 0
pause = 0

copyright_text = ""
gamename = ENGINE_NAME
version_text = ENGINE_VERSION

languages = true

lock = false
surf = -1
state = -1
musplayed=  0

complete_ch = 0
incomplete_ch = 0
tselec = 0
possible_chapters = 0
for (var i = 0; i < array_length(chapters); i ++) {
    if !is_struct(chapters[i])
        break
    possible_chapters ++
}

yes = loc("chapter_select_yes")
no = loc("chapter_select_no")

txt = ""

save_chs =  []

event_user(0)

// transitions
trans_shrink = 0
animate(0, 1, 20, anime_curve.linear, id, "alpha")