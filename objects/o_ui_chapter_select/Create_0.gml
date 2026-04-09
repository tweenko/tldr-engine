chapters = [
	{
		name: "chapter_1", // will be localized when drawn
		exec: function(caller) {
			music_stop(0)
			audio_play(snd_ui_scary)
			
			animate(0, 1, 20, "linear", caller, "trans_shrink")
			
			call_later(80, time_source_units_frames, function() {
				global.chapter = 1
                
                save_entry_set_default("ROOM", room_ex_dforest)
                save_entry_set_default("CHAPTER", 1)
                
                save_reload()
				room_goto(room_save_select)
			})
		},
		icon: spr_ui_chs_ch1,
	},
	{
		name: "chapter_2",
		exec: function(caller){
			music_stop(0)
			audio_play(snd_chs_ch2)
			
			animate(0, 1, 20, "linear", caller, "trans_shrink")
			
			call_later(80, time_source_units_frames, function() {
				global.chapter = 2
                save_entry_set_default("ROOM", room_ex_city)
                save_entry_set_default("CHAPTER", 2)
                
				save_reload()
				room_goto(room_save_select)
			})
		},
		icon: spr_ui_chs_ch2,
	},
	{
		name: "chapter_3",
		exec: function(caller){
			music_stop(0)
			audio_play(snd_chs_ch3)
			
			animate(0, 1, 20, "linear", caller, "trans_shrink")
			
			call_later(80, time_source_units_frames, function() {
				global.chapter = 3
                save_entry_set_default("ROOM", room_test_main)
                save_entry_set_default("CHAPTER", 3)
                
				save_reload()
				room_goto(room_save_select)
			})
		},
		icon: spr_ui_chs_ch3,
	},
	{
		name: "chapter_4",
		exec: function(caller){
			music_stop(0)
			audio_play(snd_chs_ch4)
			
			animate(0, 1, 20, "linear", caller, "trans_shrink")
			
			call_later(80, time_source_units_frames, function() {
				global.chapter = 4
                save_entry_set_default("ROOM", room_ex_church)
                save_entry_set_default("CHAPTER", 4)
                
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
acquired_crystal = false

copyright_text = ""
gamename = GAME_NAME
version_text = GAME_VERSION
restart_upon_language_switch = false // QOL. it restarts the room in deltarune but the engine supports no restarting

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
for (var i = 0; i < array_length(chapters); i ++) {
    for (var j = 0; j < array_length(SAVE_SLOTS); j ++) {
        
    }
}

yes = loc("chapter_select_yes")
no = loc("chapter_select_no")

txt = ""

save_chs =  []

event_user(0)

// transitions
trans_shrink = 0
animate(0, 1, 20, anime_curve.linear, id, "alpha")