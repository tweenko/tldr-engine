function item_s_base() : item_base() constructor {
	type = ITEM_TYPE.SPELL
}

function item_s_act() : item_s_base() constructor {
	name = ["ACT"]
	desc = ["You can do many things.\nDon't confuse it with magic.", "--"]
	
	tp_cost = 0
}
	
function item_s_rudebuster() : item_s_base() constructor {
	name = ["Rude Buster"]
	desc = ["Deals moderate Rude-elemental damage to one foe. Depends on Attack & Magic.", "Rude Damage"]
	use_type = ITEM_USE.ENEMY
	
	tp_cost = 50
}
	
function item_s_testdmg() : item_s_base() constructor {
	name = ["Test Damage"]
	desc = ["Deals little damage to a foe.", "Test Damage"]
	use_type = ITEM_USE.ENEMY
	
	use = function() {
		cutscene_set_variable(o_enc, "exec_waiting", true)
		cutscene_func(enc_hurt_enemy, [target, 10, user])
		cutscene_dialogue(string("* {0} cast TEST DAMAGE!", party_getname(global.party_names[user])),, true)
		cutscene_set_variable(o_enc, "exec_waiting", false)
	}
	
	tp_cost = 16
}
	
function item_s_pacify() : item_s_base() constructor {
	name = ["Pacify"]
	desc = ["SPARE a tired enemy by putting them to sleep.", "Spare TIRED foe"]
	
	use_type = ITEM_USE.ENEMY
	is_mercyspell = true
	color = merge_color(c_aqua, c_blue, 0.3)
	
	tp_cost = 16
}
	
function item_s_healprayer() : item_s_base() constructor {
	name = ["Heal Prayer"]
	desc = ["Heavenly Light restores a little HP to\none party member. Depends on Magic.", "--"]
	use_type = ITEM_USE.INDIVIDUAL
	
	tp_cost = 32
}
	
function item_s_defaultaction(nname) : item_s_base() constructor {
	name = string("{0}-Action", string_upper(string_copy(nname, 0, 1)))
	desc = ["", "", "Standard"]
	
	use_type = ITEM_USE.ENEMY
	
	color = merge_color(party_getdata(nname, "color"), c_white, 0.5)
	tp_cost = 0
	is_party_act = true
}
	
function item_s_sleepmist() : item_s_base() constructor {
	name = ["Sleep Mist"]
	desc = ["A cold mist sweeps through, sparing all TIRED enemies.", "Spare TIRED foes"]
	
	use_type = ITEM_USE.ENEMY
	is_mercyspell = true
	
	color = merge_color(c_aqua, c_blue, 0.3)
	
	tp_cost = 32
}

function item_s_iceshock() : item_s_base() constructor {
	name = ["IceShock"]
	desc = ["Deal magical ICE damage to one enemy.", "Damage w/ ICE"]
	use_type = ITEM_USE.ENEMY
	
	tp_cost = 16
}