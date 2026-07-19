chapters = [
	new chapter_option("chapter_1", spr_ui_chs_ch1, snd_ui_scary, 1, room_ex_dforest),
	new chapter_option("chapter_2", spr_ui_chs_ch2, snd_chs_ch2, 2, room_ex_city),
	new chapter_option("chapter_3", spr_ui_chs_ch3, snd_chs_ch3, 3, room_test_main, ,spr_ui_chs_ch3_completed),
	new chapter_option("chapter_4", spr_ui_chs_ch4, snd_chs_ch4, 4, room_ex_church),
	new chapter_option("chapter_5", spr_ui_chs_ch5, snd_chs_ch5, 5, room_test_main),
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