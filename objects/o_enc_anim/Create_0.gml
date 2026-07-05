audio_play(snd_tensionhorn)

background = function(){with o_eff_bg enc_background()}
bulletdark = function(){with o_eff_bg enc_bulletdark()}
effbg = instance_create_depth(0, 0, DEPTH_ENCOUNTER.BACKGROUND, o_eff_bg)

get_leader().moveable_battle = false
alarm[0] = 8

epic = false // whether it's the full animation or not
save_pos = []

encounter_data = {}
save_follow = []

enemy_objects = []
alarm[4] = 1