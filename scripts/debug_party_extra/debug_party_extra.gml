
function party_m_kris2(_initialized_name) : party_m(_initialized_name) constructor {
	name = "party_kris2_name"
    action_letter = "party_kris2_action_letter"
	obj = o_actor_kris_1
	
	// colors
	color = c_aqua
	darkcolor = c_blue
	iconcolor = #00A2E8
	
	// stats
	lv =	save_get("chapter")
	desc =	"party_kris2_desc"
	power_stats = [
        new party_power_stat_unknown(),
        new party_power_stat_unknown(),
        new party_power_stat_images("party_stat_guts", spr_ui_menu_icon_fire, 2),
	]
	
	max_hp =	90
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
    s_name = "kris"
	s_state =		""
	s_substate =	""
	s_icon =		spr_ui_kris_icon
	s_icon_ow =		spr_ui_kris_head
	s_icon_weapon = spr_ui_menu_weapon_sword
	s_battle_intro =	1 // 1 for attack, 0 for full intro	
	
	battle_sprites = { // [sprite, whether stop at the end (or change to what sprite), (image speed of the upcoming sprite)]
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
}
function party_m_susie2(_initialized_name) : party_m(_initialized_name) constructor {
	name = "party_susie2_name"
    action_letter = "party_susie2_action_letter"
	obj = o_actor_susie_1
	
	// colors
	color = c_fuchsia
	darkcolor = c_purple
	iconcolor = #EA79C8
	
	// stats
	lv =	save_get("chapter")
	desc =	"party_susie_desc"
	power_stats = [
        new party_power_stat("party_susie2_stat_rudeness", spr_ui_menu_icon_demon, 89),
        new party_power_stat("party_susie2_stat_purple", spr_ui_menu_icon_demon, "Yes"),
        new party_power_stat_images("party_stat_guts", spr_ui_menu_icon_fire, 2),
	]
	
	max_hp =	110
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
        new item_s_susieheal({progress: 3, uses: 0}),
        new item_s_scythemare()
	]
	
	// sprites
    s_name = "susie"
	s_state =		"" // serious, eyes, serious_eyes, bangs
	s_substate =	""
	s_icon =		spr_ui_susie_icon
	s_icon_ow =		spr_ui_susie_head
	s_icon_weapon = spr_ui_menu_weapon_axe
	s_battle_intro =	1 // 1 for attack, 0 for full intro	
	
	battle_sprites = { // [sprite, whether stop at the end (or change to what sprite), (image speed of the upcoming sprite)]
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
}
function party_m_ralsei2(_initialized_name) : party_m(_initialized_name) constructor {
	name = "party_ralsei2_name"
    action_letter = "party_ralsei2_action_letter"
	obj = o_actor_ralsei_1
	
	// colors
	color = c_lime
	darkcolor = c_green
	iconcolor = #B5E61D
	
	// stats
	lv =	save_get("chapter")
	desc =	"party_ralsei2_desc"
	power_stats = [
        new party_power_stat("party_ralsei2_stat_sweetness", spr_ui_menu_icon_lollipop, 97),
        new party_power_stat_images("party_ralsei2_stat_fluffiness", spr_ui_menu_icon_fluff, 2, 130),
        new party_power_stat_images("party_stat_guts", spr_ui_menu_icon_fire, 0),
	]
	
	max_hp =	70
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
		new item_s_healprayer(),
        new item_s_revivesong(),
	]
	
	// sprites
    s_name = "ralsei"
	s_state =		"" // sad, sad_subtle, hat, serious
	s_substate =	""
	s_icon =		spr_ui_ralsei_icon
	s_icon_ow =		spr_ui_ralsei_head
	s_icon_weapon = spr_ui_menu_weapon_scarf
	s_battle_intro =	0 // 1 for attack, 0 for full intro	
	
	battle_sprites = { // [sprite, whether stop at the end (or change to what sprite), (image speed of the upcoming sprite)]
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
        revivesong_sing_ready: spr_ralsei_sing_ready,
        revivesong_sing: spr_ralsei_sing,
	}
}
function party_m_noelle2(_initialized_name) : party_m(_initialized_name) constructor {
	name = "party_noelle2_name"
    action_letter = "party_noelle2_action_letter"
	obj = o_actor_noelle_1
	
	// colors
	color = c_yellow
	darkcolor = c_yellow
	iconcolor = #FFFF00
	
	// stats
	lv =	1
	desc =	"party_noelle_desc"
	power_stats = [
        new party_power_stat("party_noelle2_stat_coldness", spr_ui_menu_icon_snow, 47),
        new party_power_stat("party_noelle2_stat_boldness", spr_ui_menu_icon_exclamation, 100),
        new party_power_stat_images("party_stat_guts", spr_ui_menu_icon_fire, 0),
	] 
    
    max_hp =	90
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
    s_name = "noelle"
	s_state =		""
	s_substate =	""
	s_icon =		spr_ui_noelle_icon
	s_icon_ow =		spr_ui_noelle_head
	s_icon_weapon = spr_ui_menu_weapon_ring
	s_battle_intro =	0 // 1 for attack, 0 for full intro	
	
	battle_sprites = { // [sprite, whether stop at the end (or change to what sprite), (image speed of the upcoming sprite)]
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
}