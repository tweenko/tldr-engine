party_setfollow(false)

// animate the party in
for (var i = 0; i < array_length(global.party_names); ++i) {
	var obj = party_get_inst(global.party_names[i])
	var startpos = guipos_y() + 130 - 20*array_length(global.party_names)
	
	if array_length(global.party_names) == 3 
		startpos = guipos_y() + 64
	
	do_anime(obj.x, guipos_x() + 52, 10, "linear", function(v, obj) {
		if instance_exists(obj) 
			obj.x = v
	}, obj)
	do_anime(obj.y, startpos + i*44, 10, "linear", function(v, obj) {
		if instance_exists(obj) 
			obj.y = v
	}, obj)
	
	var m = party_getdata(global.party_names[i], "s_battle_intro")
	
	if m == 0 
		obj.sprite_index = enc_getparty_sprite(i, "intro")
	else if m == 1 {}
	else if m == 2 
		obj.sprite_index = enc_getparty_sprite(i, "introb")
	
	obj.image_speed = 1
	obj.trail = true
	obj.is_in_battle = true
}

// animate the enemies in
for (var i = 0; i < array_length(encounter_data.enemies); ++i) {
	var xx = guipos_x() + 270
	var yy = guipos_y() + 130 - 20*array_length(encounter_data.enemies) + 40*i
	
	if struct_exists(encounter_data, "enemies_pos") {
		if i < array_length(encounter_data.enemies_pos) {
			if !array_equals(encounter_data.enemies_pos[i], []) {
				if encounter_data.enemies_pos[i][2] {
					xx += encounter_data.enemies_pos[i][0]
					yy += encounter_data.enemies_pos[i][1]
				}
				else {
					xx = encounter_data.enemies_pos[i][0] + guipos_x()
					yy = encounter_data.enemies_pos[i][1] + guipos_y()
				}
			}
		}
	}
	
	var obj = noone
	var a = actor_find(encounter_data.enemies[i].obj, x, y)
	
	var create = true // whether to create the actors
	
	if a != noone {
		if !a.is_in_battle {
			obj = a
			create = false
		}
	}
	if create 
		obj = actor_create(encounter_data.enemies[i].obj, guipos_x() + 320 + 100,guipos_y() + 120, 0)
	
	do_animate(obj.x, xx, 10, "linear", obj, "x")
	do_animate(obj.y, yy, 10, "linear", obj, "y")
	
	obj.image_index = 0
	obj.hurt = 0
	obj.is_in_battle = true
	
	encounter_data.enemies[i].actor_id = obj
	encounter_data.enemies[i].slot = i
}

var inst = instance_create(o_eff_bg,,,DEPTH_ENCOUNTER.BACKGROUND)
inst.bgtype = encounter_data.bg_type

alarm[2] = 10