chapters = [
	{
		name: loc("chapter_1"),
		exec: function(caller) {
			music_stop(0)
			audio_play(snd_ui_scary)
			
			do_animate(0, 1, 20, "linear", caller, "trans_shrink")
			
			call_later(80, time_source_units_frames, function() {
				global.chapter = 1
				global.save = {
					NAME: "PLAYER",
					ROOM: room_ex_dforest,
					ROOM_NAME: "Forest - Example",
					TIME: 0,
					PARTY_DATA: global.party,
					PARTY_NAMES: global.party_names,
					CHAPTER: 1,
		
					//inventory
					ITEMS: global.items,
					KEY_ITEMS: global.key_items,
					WEAPONS: global.weapons,
					ARMORS: global.armors,
					STORAGE: global.storage,
	
					STATES: global.states,
					RECRUITS: {},
					RECRUIT_PROGRESS: {},
		
					CRYSTAL: false,
					COMPLETED: false,
					COMPLETE_ROOM: "",
					COMPLETE_TIME: 0,
				}
				
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
			
			do_animate(0, 1, 20, "linear", caller, "trans_shrink")
			
			call_later(80, time_source_units_frames, function() {
				global.chapter = 2
				global.save = {
					NAME: "PLAYER",
					ROOM: room_ex_city,
					ROOM_NAME: "Cyber City - Example",
					TIME: 0,
					PARTY_DATA: global.party,
					PARTY_NAMES: global.party_names,
					CHAPTER: 2,
		
					//inventory
					ITEMS: global.items,
					KEY_ITEMS: global.key_items,
					WEAPONS: global.weapons,
					ARMORS: global.armors,
					STORAGE: global.storage,
	
					STATES: global.states,
					RECRUITS: {},
					RECRUIT_PROGRESS: {},
		
					CRYSTAL: false,
					COMPLETED: false,
					COMPLETE_ROOM: "",
					COMPLETE_TIME: 0,
				}
				
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
			
			do_animate(0, 1, 20, "linear", caller, "trans_shrink")
			
			call_later(80, time_source_units_frames, function() {
				global.chapter = 3
				global.save = {
					NAME: "PLAYER",
					ROOM: room_test_main,
					ROOM_NAME: "I was lazy, sorry",
					TIME: 0,
					PARTY_DATA: global.party,
					PARTY_NAMES: global.party_names,
					CHAPTER: 3,
		
					//inventory
					ITEMS: global.items,
					KEY_ITEMS: global.key_items,
					WEAPONS: global.weapons,
					ARMORS: global.armors,
					STORAGE: global.storage,
	
					STATES: global.states,
					RECRUITS: {},
					RECRUIT_PROGRESS: {},
		
					CRYSTAL: false,
					COMPLETED: false,
					COMPLETE_ROOM: "",
					COMPLETE_TIME: 0,
				}
				
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
			
			do_animate(0, 1, 20, "linear", caller, "trans_shrink")
			
			call_later(80, time_source_units_frames, function() {
				global.chapter = 4
				global.save = {
					NAME: "PLAYER",
					ROOM: room_ex_church,
					ROOM_NAME: "Prophecy Room Idk",
					TIME: 0,
					PARTY_DATA: global.party,
					PARTY_NAMES: global.party_names,
					CHAPTER: 2,
		
					//inventory
					ITEMS: global.items,
					KEY_ITEMS: global.key_items,
					WEAPONS: global.weapons,
					ARMORS: global.armors,
					STORAGE: global.storage,
	
					STATES: global.states,
					RECRUITS: {},
					RECRUIT_PROGRESS: {},
		
					CRYSTAL: false,
					COMPLETED: false,
					COMPLETE_ROOM: "",
					COMPLETE_TIME: 0,
				}
				
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
gamename = "tlDR Engine"
version_text = "v0.9.0"

languages = true

lock = false
surf = -1
state = -1
musplayed=  0

complete_ch = 0
incomplete_ch = 0
tselec = 0

yes = loc("ui_chs_yes")
no = loc("ui_chs_no")

txt = ""

save_chs =  []

event_user(0)

// transitions
trans_shrink = 0
do_anime(0, 1, 20, "linear", function(v) {
	if instance_exists(id) 
		id.alpha = v
})