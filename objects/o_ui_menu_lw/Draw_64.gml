{ // top
	ui_dialoguebox_create(32, 52 + yy, 142, 110)
	
	draw_set_font(loc_font("main"))
	draw_set_color(c_white)
	draw_text_transformed(46, 60 + yy, loc(save_get("lw_name")), 2, 2, 0)
	draw_set_font(font_lwmenu)

	draw_text_transformed(46, 100-6 + yy, loc("menu_lw_lv"), 2, 2, 0)
	draw_text_transformed(82, 100-6 + yy, save_get("lw_lv"), 2, 2, 0)
	draw_text_transformed(46, 118-6 + yy, loc("menu_lw_hp"), 2, 2, 0)
	draw_text_transformed(82, 118-6 + yy, $"{save_get("lw_hp")}/{save_get("lw_maxhp")}", 2, 2, 0)
	draw_text_transformed(46, 136-6 + yy, "$", 2, 2, 0)
	draw_text_transformed(80, 136-6 + yy, save_get("lw_money"), 2, 2, 0)

	draw_set_font(loc_font("main"))
	draw_set_color(c_white)
}
{ // middle
	ui_dialoguebox_create(32, 168, 142, 148 - 36*3 + 36*array_length(options))
	
	for (var i = 0; i < array_length(options); ++i) {
		if selection == i && state == 0 
			draw_sprite_ext(spr_ui_soul, 0, 56, 196 + 36*i, 2, 2, 0, c_red, 1)
		if !options[i].selectable 
            draw_set_color(c_gray)
        
		draw_text_transformed(84, 196 + 36*i - 8, options[i].name, 2, 2, 0)
		draw_set_color(c_white)
	}
	draw_set_color(c_white)
}
if state == 1 || state == 2 { // items
	var iarr = item_get_array(6)
	
	ui_dialoguebox_create(188, 52, 346, 362)
	
	for (var i = 0; i < array_length(iarr); ++i) {
		if i_selection == i && state == 1 
			draw_sprite_ext(spr_ui_soul, 0, 232-24, 88 + i*32, 2, 2, 0, c_red, 1)
        
		draw_text_transformed(232, 80 + i*32, item_get_name(iarr[i]), 2, 2, 0)
	}
	
	if ip_selection == 0 && state == 2
		draw_sprite_ext(spr_ui_soul, 0, 208, 368, 2, 2, 0, c_red, 1)
	draw_text_transformed(232, 360, loc("menu_lw_item_use"), 2, 2, 0)
    
	if ip_selection == 1 && state == 2
		draw_sprite_ext(spr_ui_soul, 0, 328-24, 368, 2, 2, 0, c_red, 1)
	draw_text_transformed(328, 360, loc("menu_lw_item_info"), 2, 2, 0)
    
	if ip_selection == 2 && state == 2
		draw_sprite_ext(spr_ui_soul, 0, 442-24, 368, 2, 2, 0, c_red, 1)
	draw_text_transformed(442, 360, loc("menu_lw_item_drop"), 2, 2, 0)
}
if state == 3 { // stats
	var stats = {
		name: save_get("lw_name"),
		since_chapter: save_get("lw_since_chapter"), // undefined if you don't want it to be displayed
		lv: save_get("lw_lv"),
		
		hp: save_get("lw_hp"),
		hp_max: save_get("lw_maxhp"),
		
		attack: 1,
		attack_base: 9,
		defense: 0,
		defense_base: 10,
		
		experience: 0,
		next_exp: 10,
		
		wp_name: item_get_name(global.lw_weapon),
		am_name: item_get_name(global.lw_armor),
		money: save_get("lw_money"),
	}
    
    if is_undefined(global.lw_weapon)
        stats.wp_name = loc("menu_lw_equipped_nothing");
    else {
        if !is_undefined(global.lw_weapon)
    	   stats.attack = global.lw_weapon.stats.attack;
    }
    if is_undefined(global.lw_armor)
        stats.am_name = loc("menu_lw_equipped_nothing");
    else {
        if !is_undefined(global.lw_armor)
    	   stats.defense = global.lw_armor.stats.defense;
    }
	
	var att = stats.attack_base + stats.attack
	var def = stats.defense_base + stats.defense
	
	ui_dialoguebox_create(188, 52, 346, 418)
	draw_text_transformed(216, 84, $"\"{stats.name}\"", 2, 2, 0)
    if stats.since_chapter != undefined
	    draw_text_transformed(384, 84, loc_string("menu_lw_stats_since_chapter", stats.since_chapter), 2, 2, 0)
	
	draw_text_transformed(216, 144, loc("menu_lw_lv"), 2, 2, 0)
	draw_text_transformed(256, 144, $"{stats.lv}", 2, 2, 0)
	draw_text_transformed(216, 176, loc("menu_lw_hp"), 2, 2, 0)
	draw_text_transformed(256, 176, $"{stats.hp} / {stats.hp_max}", 2, 2, 0)
	
	draw_text_transformed(216, 240, loc("menu_lw_at"), 2, 2, 0)
	draw_text_transformed(256, 240, $"{att} ({stats.attack})", 2, 2, 0)
	draw_text_transformed(216, 272, loc("menu_lw_df"), 2, 2, 0)
	draw_text_transformed(256, 272, $"{def} ({stats.defense})", 2, 2, 0)
	
	draw_text_transformed(384, 240, loc_string("menu_lw_stats_exp", stats.experience), 2, 2, 0)
	draw_text_transformed(384, 272, loc_string("menu_lw_stats_next", stats.next_exp), 2, 2, 0)
	
    var __txt = loc("menu_lw_stats_weapon")
    var __xx = 216 + string_width(__txt)*2 + 8
	draw_text_transformed(216, 332, loc("menu_lw_stats_weapon"), 2, 2, 0)
    draw_text_xfit(__xx, 332, stats.wp_name, (524 - __xx)*2, 2, 2)
    
    __txt = loc("menu_lw_stats_armor")
    __xx = 216 + string_width(__txt)*2 + 8
	draw_text_transformed(216, 364, loc("menu_lw_stats_armor"), 2, 2, 0)
	draw_text_xfit(__xx, 364, stats.am_name, (524 - __xx)*2, 2, 2)
    
	draw_text_transformed(216, 404, loc_string("menu_lw_stats_money", stats.money), 2, 2, 0)
	
}
if state == 4 { // cell
    ui_dialoguebox_create(188, 52, 346, 270)
    
    for (var i = 0; i < array_length(phone_numbers); i ++) {
        var __number = phone_numbers[i]
        
        if c_selection == i
            draw_sprite_ext(spr_ui_soul, 0, 232-24, 88+i*32, 2, 2, 0, c_red, 1)
        draw_text_transformed(232, 80 + i*32, __number.name, 2, 2, 0)
    }
}