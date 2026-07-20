
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
for (var i = 0; i < array_length(o_world.chapters); i ++) {
    if !is_struct(o_world.chapters[i])
        break
    possible_chapters ++
}
for (var i = 0; i < array_length(o_world.chapters); i ++) {
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