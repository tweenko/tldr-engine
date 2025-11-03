global.party = {}

/// @desc intializes the party stuff
function party_init() {
    party_m_initialize("kris", party_m_kris)
    party_m_initialize("susie", party_m_susie)
    party_m_initialize("ralsei", party_m_ralsei)
    party_m_initialize("noelle", party_m_noelle)
    
	global.party_names = []
}
function party_m_initialize(_name, _constructor) {
    struct_set(global.party, _name, new _constructor())
}

/// @desc applies the equipment to party members (only for raw saves)
function party_apply_equipment() {
    for (var i = 0; i < array_length(global.party_names); i ++) {
        item_apply(party_getdata(global.party_names[i], "weapon"), global.party_names[i])
        item_apply(party_getdata(global.party_names[i], "armor1"), global.party_names[i])
        item_apply(party_getdata(global.party_names[i], "armor2"), global.party_names[i])
    }
}
function party_m_calculate_hp(base_hp, level) {
    if level == 1
        return base_hp
    else if level == 2
        return base_hp + 30
    else
        return base_hp + 30 + 40*level
}
    
function party_m() constructor {
	name = "???"
    action_letter = "?"
	
	// colors
	color =		c_gray
	darkcolor =	c_dkgray
	iconcolor =	c_gray
	
	// stats
	lv =	0
	desc =	"???"
	power_stats = [
		["--", 0, spr_ui_menu_icon_exclamation],
		["--", 0, spr_ui_menu_icon_exclamation],
		["party_stat_guts", 0, spr_ui_menu_icon_fire],
	]
	
	hp =		50
	max_hp =	50
	attack =	16
	defense =	10
	magic =		0
	element_resistance = {
	}
	
	// inventory
	weapon = undefined
	armor1 = undefined
	armor2 = undefined
	spells = [
		new item_s_testdmg(),
	]
	
	// sprites
	s_state =		""
	s_substate =	""
	s_icon =		spr_ui_default_icon
	s_icon_ow =		spr_ui_default_head
	s_icon_weapon = spr_ui_menu_weapon_axe
	s_battle_intro =	1 // 1 for attack, 0 for full intro	
	
	battle_sprites = { // [sprite, whether stop at the end (or change to what sprite), (image speed)]
		act: [spr_bsusie_act, true],
		actready: spr_bsusie_actready,
		actend: [spr_bsusie_actend, "idle", 1],
		attack: [spr_bsusie_attack, true],
		attackready: spr_bsusie_attackready,
		defeat: spr_bsusie_defeat,
		defend: [spr_bsusie_defend, true],
		hurt: spr_bsusie_hurt,
		idle: spr_bsusie_idle,
		intro: spr_susie_right,
		introb: spr_susie_right,
		itemuse: [spr_bsusie_item, "idle", 1],
		itemready: spr_bsusie_itemready,
		spell: [spr_bsusie_spell, "idle", 1],
		spellready: spr_bsusie_spellready,
		victory: [spr_bsusie_victory, true],
		spare: [spr_bsusie_act, "idle", 1],
		attack_eff: spr_bsusie_attackeff,
		
		rudebuster: [spr_bsusie_rudebuster, 14],
	}
		
	// system
	obj = {
		obj: o_actor,
		var_struct: {
			name: "susie"
		},
	}
	
	actor_id = noone
	is_down = false
}

function party_m_kris() : party_m() constructor {
	name = "party_kris_name"
    action_letter = "party_kris_action_letter"
	
	// colors
	color = c_aqua
	darkcolor = c_blue
	iconcolor = #00A2E8
	
	// stats
	lv =	save_get("chapter")
	desc =	"party_kris_desc"
	power_stats = [
		"???",
		"???",
		["party_stat_guts", 2, spr_ui_menu_icon_fire],
	]
	
	max_hp =	party_m_calculate_hp(90, lv)
    hp =		max_hp
	attack =	12
	defense =	2
	magic =		0
	element_resistance = {
	}
	
	// inventory
    weapon = new item_w_spookysword()
    armor1 = new item_a_ambercard()
    armor2 = new item_a_ambercard()
	spells = [
		new item_s_act()
	]
	
	// sprites
	s_state =		""
	s_substate =	""
	s_icon =		spr_ui_kris_icon
	s_icon_ow =		spr_ui_kris_head
	s_icon_weapon = spr_ui_menu_weapon_sword
	s_battle_intro =	1 // 1 for attack, 0 for full intro	
	
	battle_sprites = { // [sprite, whether stop at the end (or change to what sprite), (image speed)]
		act: [spr_bkris_act, true],
		actready: spr_bkris_actready,
		actend: [spr_bkris_actend, "idle", 1],
		attack: [spr_bkris_attack, true],
		attackready: spr_bkris_attackready,
		defeat: spr_bkris_defeat,
		defend: [spr_bkris_defend, true],
		hurt: spr_bkris_hurt,
		idle: spr_bkris_idle,
		intro: [spr_bkris_intro, true],
		introb: spr_bkris_introb,
		itemuse: [spr_bkris_item, "idle", 1],
		itemready: spr_bkris_itemready,
		victory: [spr_bkris_victory, true],
		spare: [spr_bkris_act, "idle", 1],
		attack_eff: spr_bkris_attackeff,
	}
		
	// system
	obj = {
		obj: o_actor_kris,
		var_struct: {
			name: "kris"
		},
	}
}
function party_m_susie() : party_m() constructor {
	name = "party_susie_name"
    action_letter = "party_susie_action_letter"
	
	// colors
	color = c_fuchsia
	darkcolor = c_purple
	iconcolor = #EA79C8
	
	// stats
	lv =	save_get("chapter")
	desc =	"party_susie_desc"
	power_stats = [
		["party_susie_stat_rudeness", 89, spr_ui_menu_icon_demon],
		["party_susie_stat_purple", "Yes", spr_ui_menu_icon_demon],
		["party_stat_guts", 2, spr_ui_menu_icon_fire],
	]
	
	max_hp =	party_m_calculate_hp(110, lv)
    hp =        max_hp
	attack =	16
	defense =	2
	magic =		1
	element_resistance = {
	}
	
	// inventory
    weapon = new item_w_mane_ax()
    armor1 = new item_a_ambercard()
    armor2 = new item_a_ambercard()
	spells = [
		new item_s_rudebuster(),
        new item_s_susieheal()
	]
	
	// sprites
	s_state =		"" // serious, eyes, serious_eyes, bangs
	s_substate =	""
	s_icon =		spr_ui_susie_icon
	s_icon_ow =		spr_ui_susie_head
	s_icon_weapon = spr_ui_menu_weapon_axe
	s_battle_intro =	1 // 1 for attack, 0 for full intro	
	
	battle_sprites = { // [sprite, whether stop at the end (or change to what sprite), (image speed)]
		act: [spr_bsusie_act, true],
		actready: spr_bsusie_actready,
		actend: [spr_bsusie_actend, "idle", 1],
		attack: [spr_bsusie_attack, true],
		attackready: spr_bsusie_attackready,
		defeat: spr_bsusie_defeat,
		defend: [spr_bsusie_defend, true],
		hurt: spr_bsusie_hurt,
		idle: spr_bsusie_idle,
		intro: spr_susie_right,
		introb: spr_susie_right,
		itemuse: [spr_bsusie_item, "idle", 1],
		itemready: spr_bsusie_itemready,
		spell: [spr_bsusie_spell, "idle", 1],
		spellready: spr_bsusie_spellready,
		victory: [spr_bsusie_victory, true],
		spare: [spr_bsusie_act, "idle", 1],
		attack_eff: spr_bsusie_attackeff,
				
		rudebuster: [spr_bsusie_rudebuster, 14],
	}
		
	// system
	obj = {
		obj: o_actor_susie,
		var_struct: {
			name: "susie"
		},
	}
}
function party_m_ralsei() : party_m() constructor {
	name = "party_ralsei_name"
    action_letter = "party_ralsei_action_letter"
	
	// colors
	color = c_lime
	darkcolor = c_green
	iconcolor = #B5E61D
	
	// stats
	lv =	save_get("chapter")
	desc =	"party_ralsei_desc"
	power_stats = [
		["party_ralsei_stat_sweetness", 97, spr_ui_menu_icon_lollipop],
		["party_ralsei_stat_fluffiness", 2, spr_ui_menu_icon_fluff],
		["party_stat_guts", 0, spr_ui_menu_icon_fire],
	]
	
	max_hp =	party_m_calculate_hp(70, lv)
    hp =		max_hp
	attack =	8
	defense =	2
	magic =		9
	element_resistance = {
	}
	
	// inventory
    weapon = new item_w_red_scarf()
    armor1 = new item_a_ambercard()
    armor2 = new item_a_white_ribbon()
	spells = [
		new item_s_pacify(),
		new item_s_healprayer()
	]
	
	// sprites
	s_state =		"" // sad, sad_subtle, hat
	s_substate =	""
	s_icon =		spr_ui_ralsei_icon
	s_icon_ow =		spr_ui_ralsei_head
	s_icon_weapon = spr_ui_menu_weapon_scarf
	s_battle_intro =	1 // 1 for attack, 0 for full intro	
	
	battle_sprites = { // [sprite, whether stop at the end (or change to what sprite), (image speed)]
		act: [spr_bralsei_act, true],
		actready: spr_bralsei_actready,
		actend: [spr_bralsei_actend, "idle", 1],
		attack: [spr_bralsei_attack, true],
		attackready: spr_bralsei_attackready,
		defeat: spr_bralsei_defeat,
		defend: [spr_bralsei_defend, true],
		hurt: spr_bralsei_hurt,
		idle: spr_bralsei_idle,
		intro: [spr_bralsei_intro, true],
		introb: spr_ralsei_right,
		itemuse: [spr_bralsei_item, "idle", 1],
		itemready: spr_bralsei_itemready,
		spell: [spr_bralsei_spell, "idle", 1],
		spellready: spr_bralsei_spellready,
		victory: [spr_bralsei_victory, true],
		spare: [spr_bralsei_act, "idle", 1],
		attack_eff: spr_bralsei_attackeff,
	}
		
	//system
	obj = {
		obj: o_actor_ralsei,
		var_struct: {
			name: "ralsei"
		},
	}
}
function party_m_noelle() : party_m() constructor {
	name = "party_noelle_name"
    action_letter = "party_noelle_action_letter"
	
	// colors
	color = c_yellow
	darkcolor = c_yellow
	iconcolor = #FFFF00
	
	// stats
	lv =	1
	desc =	"party_noelle_desc"
	power_stats = [
		["party_noelle_stat_coldness", 47, spr_ui_menu_icon_snow],
		["party_noelle_stat_boldness", 100, spr_ui_menu_icon_exclamation],
		["party_stat_guts", 0, spr_ui_menu_icon_fire],
	] 
    
    max_hp =	party_m_calculate_hp(90, lv)
	hp =		max_hp
	attack =	3
	defense =	1
	magic =		11
	element_resistance = {
	}
	
	// inventory
    weapon = new item_w_snowring()
    armor1 = new item_a_silver_watch()
    armor2 = new item_a_royal_pin()
	spells = [
		new item_s_healprayer(),
		new item_s_sleepmist(),
		new item_s_iceshock(),
	]
	
	// sprites
	s_state =		""
	s_substate =	""
	s_icon =		spr_ui_noelle_icon
	s_icon_ow =		spr_ui_noelle_head
	s_icon_weapon = spr_ui_menu_weapon_ring
	s_battle_intro =	0 // 1 for attack, 0 for full intro	
	
	battle_sprites = { // [sprite, whether stop at the end (or change to what sprite), (image speed)]
		act: [spr_bnoelle_act, true],
		actready: spr_bnoelle_actready,
		actend: [spr_bnoelle_actend, "idle", 1],
		attack: [spr_bnoelle_attack, true],
		attackready: spr_bnoelle_attackready,
		defeat: spr_bnoelle_defeat,
		defend: spr_bnoelle_defend,
		hurt: spr_bnoelle_hurt,
		idle: spr_bnoelle_idle,
		intro: [spr_bnoelle_intro, true],
		introb: spr_noelle_right,
		itemuse: [spr_bnoelle_item, "idle", 1],
		itemready: spr_bnoelle_itemready,
		spell: [spr_bnoelle_spell, "idle", 1],
		spellready: spr_bnoelle_spellready,
		victory: [spr_bnoelle_victory, true],
		spare: [spr_bnoelle_act, "idle", 1],
		attack_eff: spr_bnoelle_attackeff,
	}
		
	// system
	obj = {
		obj: o_actor_noelle,
		var_struct: {
			name: "noelle"
		},
	}
}