///@desc changes the hp of a party member, adjusts for whether or not you're in battle and also checks for dying
function party_hpchange(name, heal, caller = noone, sfx = -1) {
	if heal > 0 { // heal
		if sfx == -1
			sfx = snd_heal
		audio_play(sfx,,,,1)
		
		struct_set(party_nametostruct(name), "hp", min(party_getdata(name, "hp") + heal, party_getdata(name, "max_hp")))
		
		if caller.object_index == o_ui_menu { // if in menu
			var xoff = 319.5 + array_length(global.party_names) * -213/2
			var inst = instance_create(o_ui_menu_healeffect, xoff + 70 + 213*array_get_index(global.party_names, name))
			
			inst.text = string("+{0}", heal)
		}
		else if caller == o_enc // if in battle or in a cutscene
			|| caller.object_index == o_cutscene_inst
			|| caller.object_index == o_enc
		{ 
			var o = party_get_inst(name)
			var txt = heal
			
			if party_getdata(name, "hp") > 0 && party_getdata(name, "is_down") && o_enc.battle_state == "post_turn" {
				txt = "up"
				party_setdata(name, "hp", round(party_getdata(name, "max_hp") * .17))
				party_setdata(name, "is_down", false)
			}
			else if party_getdata(name, "hp") > 0 && party_getdata(name, "is_down") 
				party_setdata(name, "is_down", false)
			
			if party_getdata(name, "hp") >= party_getdata(name, "max_hp")
				txt = "max"
			
			instance_create(o_text_hpchange, o.x, o.y - o.myheight/2, o.depth-100, {
				draw: txt, 
				mode: 0
			})
			instance_create(o_eff_healeffect,,,, {target: o})
            
            var a = animate(.5, 1, 4, anime_curve.linear, o, "flash")
                a._add(0, 6, anime_curve.linear)
                a._start()
		}
	}
	else if heal == 0 { // miss
		if caller.object_index == o_cutscene_inst // if in battle
			||caller.object_index == o_enc 
		{
			var o = party_get_inst(name)
			instance_create(o_text_hpchange, o.x, o.y-o.myheight/2, o.depth-100, {draw: "miss", mode: 0})
		}
	}
	else if heal < 0 { // hurt
		if sfx == -1
			sfx = snd_hurt
		
		struct_set(party_nametostruct(name), "hp", min(party_getdata(name, "hp") + heal, party_getdata(name, "max_hp")))
		
		if caller == o_enc // if in battle
			|| caller.object_index == o_cutscene_inst
			|| caller.object_index == o_enc
		{
			var txt = heal
			var o = party_get_inst(name)
			
            if instance_exists(o_enc) {
                o_enc.pm_hurt[party_getpos(name)] = 15
            }
            
			if o.is_in_battle {
				o.hurt = 20
                screen_shake(5)
				animate(6, 0, 10, anime_curve.linear, o, "shake")
				
				if !party_getdata(name, "is_down") && !party_isup(name) {
					party_setdata(name, "hp", round(party_getdata(name, "max_hp") / -2))
					party_setdata(name, "is_down", true)
					
					txt = "down"
				}
			}
			else {
				o.hurt = 5
				screen_shake(5)
				
				if instance_exists(get_leader())
					get_leader().dodge_mysoul.i_frames = ENC_SETUP_SOUL_INV
				
				if !instance_exists(o_ui_menu) 
					instance_create(o_ui_menu,,,, {only_hp: true})
				
				if get_leader().moveable_menu == false 
					get_leader().moveable_menu = true
				else 
					o_ui_menu.timer = 100
				
				if party_getdata(name, "hp") <= 1 {
					var alive = false
					for (var i = 0; i < array_length(global.party_names); ++i) {
					    if party_getdata(global.party_names[i], "hp") > 1 {
							alive = true
							break
						}
					}
					
					if alive 
						party_setdata(name, "hp", 1)
				}
			}
			
			instance_create(o_text_hpchange, o.x, o.y - o.myheight/2, o.depth - 100, {
				draw: txt, 
				mode: 0
			})
			audio_play(sfx,,,,1)
		}
		
		party_check_gameover()
	}
}

///@desc kind of a fake function that just calls party_hpchange
/// @arg {string} name the name of the party member to heal
/// @arg {real} heal the amount to heal a party member for
/// @arg {Id.Instance|Asset.GMObject} caller the object that will be used as the reference point for the visual response
function party_heal(name, heal, caller = -1, sfx = -1) {
	party_hpchange(name, heal, caller, sfx)
}
/// @desc kind of a fake function that just calls party_hpchange but makes the heal argument negative to hurt the party member instead
/// @arg {string} name the name of the party member to damage
/// @arg {real} hurt the damage to be dealed
/// @arg {Id.Instance|Asset.GMObject} caller the object that will be used as the reference point for the visual response
/// @arg {real} sfx sound effect that will be played upon dealing damage
function party_hurt(name, hurt, caller = -1, sfx = -1) {
	party_hpchange(name, -hurt, caller, sfx)
}
///@desc hurt a party member while calculating the damage of with the defense and attack of characters
/// @arg {string} name the name of the party member to damage
/// @arg {real} enemy_attack the enemy's attack that will be used for calculation
/// @arg {Id.Instance|Asset.GMObject} caller the object that will be used as the reference point for the visual response
/// @arg {string} element the element of the attack that will be used for calculation
/// @arg {real} sfx sound effect that will be played upon dealing damage
function party_attack(name, enemy_attack, caller = -1, element = "", sfx = -1) {
    var dmg = damage(enemy_attack, name, element)
    party_hurt(name, dmg, caller, sfx)
}

///@desc heal all party members a specified amount
/// @arg {string} name the name of the party member to heal
/// @arg {real} heal the amount to heal a party member for
/// @arg {Id.Instance|Asset.GMObject} caller the object that will be used as the reference point for the visual response
function party_heal_all(heal, caller = -1) {
	for (var i = 0; i < array_length(global.party_names); ++i) {
		party_heal(global.party_names[i], heal, caller)
	}
}
///@desc hurt all party members a specified amount
/// @arg {real} hurt the damage to deal
/// @arg {Id.Instance|Asset.GMObject} caller the object that will be used as the reference point for the visual response
/// @arg {string} element the element of the attack that will be used for calculation
function party_hurt_all(hurt, caller = -1) {
	for (var i = 0; i < array_length(global.party_names); ++i) {
		party_hurt(global.party_names[i], hurt, caller)
	}
}
///@desc hurt all party members while calculating the damage of with the defense and attack of characters
/// @arg {real} enemy_attack the enemy's attack that will be used for calculation
/// @arg {Id.Instance|Asset.GMObject} caller the object that will be used as the reference point for the visual response\
/// @arg {string} element the element of the attack that will be used for calculation
function party_attack_all(att, caller = -1, element = "") {
	for (var i = 0; i < array_length(global.party_names); ++i) {
		var dmg = damage(att, global.party_names[i], element)
		party_hurt(global.party_names[i], dmg, caller)
	}
}
///@desc hurt targeted party members a specified amount
/// @arg {real} hurt the damage to deal
/// @arg {Id.Instance|Asset.GMObject} caller the object that will be used as the reference point for the visual response
function party_hurt_targets(hurt, caller = -1) {
	for (var i = 0; i < array_length(o_enc.turn_targets); ++i) {
		if !party_getdata(o_enc.turn_targets[i], "is_down") {
			party_hurt(o_enc.turn_targets[i], hurt, caller)
		}
	}
}
///@desc hurt targeted party members while calculating the damage of with the defense and attack of characters
/// @arg {real} enemy_attack the enemy's attack that will be used for calculation
/// @arg {Id.Instance|Asset.GMObject} caller the object that will be used as the reference point for the visual response
/// @arg {string} element the element of the attack that will be used for calculation
function party_attack_targets(att, caller = noone, element = "") {
	for (var i = 0; i < array_length(o_enc.turn_targets); ++i) {
		if !party_getdata(o_enc.turn_targets[i], "is_down") {
			var dmg = damage(att, o_enc.turn_targets[i], element)
			party_hurt(o_enc.turn_targets[i], dmg, caller)
		}
	}
}

///@desc check if the party is all down. if so, initiates the gameover screen
function party_check_gameover() {
	var res_ow = true
    var res_enc = true
	for (var i = 0; i < array_length(global.party_names); ++i) {
		if party_getdata(global.party_names[i], "hp") > 1 && res_ow
			res_ow = false
		if party_getdata(global.party_names[i], "hp") > 0 && res_enc
			res_enc = false
	}
	
	if res_enc && instance_exists(o_enc) 
		enc_gameover()
    else if res_ow && dodge_getalpha() > 0
        dodge_gameover()
}

///@desc	caluclates the damage for an enemy attack
///@arg	{struct}	attack	enemy's attack stat
///@arg	{string}	party_name	party member's name
/// @arg {string}   element     the element that will be used for calculation
function damage(attack, party_name, element){
	if !party_get_inst(party_name).is_in_battle 
        return attack
	
	// base calculation
	var hurt = 5*attack
	var party = party_nametostruct(party_name)
	
	// member's defense
	var dfm = 0
	for (var i = 0; i < party.defense; ++i) {
	    if hurt > 1/5 * party.max_hp 
            dfm=3
		else if hurt > 1/8 * party.max_hp 
            dfm = 2
		else 
            dfm = 1
        
		hurt -= dfm
	}
	
	// check if member is defending
	if instance_exists(o_enc){
		if o_enc.char_state[party_getpos(party_name)] == CHAR_STATE.DEFEND // defending
            hurt *= 2/3
	}
	// apply element protection
	if struct_exists(party.element_resistance, element) {
		hurt *= 1 - struct_get(party.element_resistance, element)
	}
	
	return max(1, round(hurt))
}