enum MENU_SELECTION {
	ITEMS,
	EQUIP,
	POWER,
	CONFIG
}

if instance_exists(get_leader())
	get_leader().moveable_menu = false

menuroll = 0
close = false
timer = 80
surf = -1
fading_out = false

selection = global.menu_page

// item
i_pselection = 0
i_selection = 0
i_pmselection = 0
i_select_array = global.items

// equip
e_pmselection = 0
e_pselection = 0
e_selection = 0

// power
p_pmselection = 0
p_selection = 0

// config
c_selection = 0
c_controls_selection = 0
c_holdtimer = 0

enum C_CONFIG_TYPE {
    SLIDER,
    BUTTON,
    SWITCH,
    SINGLE_SLIDER,
}
c_config = [
    {
        name: loc("menu_config_master_vol"),
        type: C_CONFIG_TYPE.SLIDER,
    
        call: method(self, function(delta) {
            o_world.volume_master += delta
            o_world.volume_master = clamp(o_world.volume_master, 0, 1)
            
            audio_master_gain(o_world.volume_master)
        }),
        display: function() {
            return $"{clamp(round(o_world.volume_master * 100), 0, 100)}%"
        }
    },
    {
        name: loc("menu_config_controls"),
        type: C_CONFIG_TYPE.BUTTON,
        call: method(self, function() {
            state = 3
        })
    },
    {
        name: loc("menu_config_simplify_vfx"),
        state: function() {
            return global.settings.SIMPLIFY_VFX
        },
        type: C_CONFIG_TYPE.SWITCH,
        call: method(self, function(_bool) {
            global.settings.SIMPLIFY_VFX = _bool
        })
    },
    // fullscreen ?
    {
        name: loc("menu_config_auto_run"),
        state: function() {
            return global.settings.AUTO_RUN
        },
        type: C_CONFIG_TYPE.SWITCH,
        call: method(self, function(_bool) {
            get_leader().auto_run = _bool
            global.settings.AUTO_RUN = _bool
        })
    },
    // border ?
    {
        name: loc("menu_config_return_title"),
        type: C_CONFIG_TYPE.BUTTON,
        call: method(self, function() {
            fader_fade(0, 1, 20, DEPTH_UI.HIGHEST)
            music_fade_all(0, 20)
            
            alarm[2] = 40
            fading_out = true
        })
    },
    {
        name: loc("menu_config_back"),
        type: C_CONFIG_TYPE.BUTTON,
        call: method(self, function() {
            state = 0
        })
    },
]

if !global.can_use_borders {
    array_insert(c_config, 3, {
        name: loc("menu_config_fullscreen"),
        state: function() {
            return window_get_fullscreen()
        },
        type: C_CONFIG_TYPE.SWITCH,
    
        call: method(self, function(_bool) {
            window_set_fullscreen(_bool)
        }),
    })
}
else {
    array_insert(c_config, 4, {
        name: loc("menu_config_border"),
        display: function() {
            return loc($"menu_config_border_mode_{global.border_mode}")
        },
        type: C_CONFIG_TYPE.SINGLE_SLIDER,
    
        call: method(self, function(delta) {
            global.border_mode += delta
            global.border_mode = (global.border_mode + global.border_mode_count) % global.border_mode_count
            
            if global.border_mode == BORDER_MODE.OFF
                borders_toggle(false)
            else
                borders_toggle(true)
            
            if global.border_mode == BORDER_MODE.DYNAMIC
                border_set(global.current_dynamic_border,, 0);
            else if global.border_mode == BORDER_MODE.SIMPLE
                border_set(border_simple,, 0);
            else if global.border_mode == BORDER_MODE.NONE
                border_set(border_none,, 0);
        }),
    })
}

c_controls = [
    INPUT_VERB.DOWN,
    INPUT_VERB.RIGHT,
    INPUT_VERB.UP,
    INPUT_VERB.LEFT,
    INPUT_VERB.SELECT,
    INPUT_VERB.CANCEL,
    INPUT_VERB.SPECIAL,
]
c_controls_changing = false
c_controls_resetfade = 0

partyreaction = array_create(party_getpossiblecount(), 0)
partyreactiontimer = array_create(party_getpossiblecount(), 0)
partyreactionlen = 5

state = 0
buffer = 0
e_move = 0
only_hp = false

i_mode = 0 // 1 for everybody

bcolor = merge_color(c_purple, c_black, 0.7)
bcolor = merge_color(bcolor, c_dkgray, 0.5)

depth = DEPTH_UI.MENU_UI;

#region bottom pm ui elements 
	ui_menu_center = (party_length() <= 3);
	
	ui_menu_x = 0;
	ui_menu_width_default = 213;
	ui_menu_width = ui_menu_center ? ui_menu_width_default : GAME_W_GUI/party_length();

	hp_bar_length_default = 76;
	hp_bar_length = 76;

	party_ui_alpha_icon = 1;
	party_ui_alpha_name = 1;
	party_ui_alpha_hp_text = 1;
	party_ui_alpha_hp_num = 1;

	menu_move_time = 15;
	compact_anim_time = 15;

	party_ui_offset_default = {
		edge : 7,
		icon : 5,
		name : 39,
		hp_text : 59,
		hp_bar : 18,
		hp : 43,
		hp_sep : 42,
		hp_max : -1
	}
	party_ui_offset = {
		edge : party_ui_offset_default.edge,
		icon : party_ui_offset_default.icon,
		name : party_ui_offset_default.name,
		hp_text : party_ui_offset_default.hp_text,
		hp_bar : party_ui_offset_default.hp_bar,	
		hp : party_ui_offset_default.hp,
		hp_sep : party_ui_offset_default.hp_sep,
		hp_max : party_ui_offset_default.hp_max
	}
	
	party_ui_menu_compacted = false;
	
#endregion

#region drawing methods
	__ui_draw_pm_list = function() {	
		var __sel = selection == MENU_SELECTION.EQUIP ? e_pmselection : p_pmselection;
		
		var _l_offset = 0
        var _r_offset = 0
        if loc_getlang() == "ja" {
            _l_offset = -16 - 6
            _r_offset = 16 + 8
        }
		
		var __center_pm_index = clamp(__sel, 1, party_length()-2);
		
		draw_text_transformed(135 + _l_offset, 107, party_getname(global.party_names[__sel],false), 2, 2, 0)
			
		for (var i = __center_pm_index-1; i <= __center_pm_index+1; ++i) {
			var c = (i == __sel ? c_white : #666666)
			if i == __sel && state == 1 {
				draw_sprite_ext(spr_ui_soul_arrows, o_world.frames/30 * 2, 108 + 50*(i - __center_pm_index+1) + _l_offset, 142, 1, 1, 0, c_red, 1)
			}
			
		    draw_sprite_ext(party_get_icon_ow(global.party_names[i]),0, 90 + 50*(i - __center_pm_index+1) + _l_offset, 160, 2, 2, 0, c, 1)
		}
		
		var _xoff_arrow = 2*sin(o_world.frames/15);
		draw_sprite_ext(spr_ui_arrow_flat, 0, 90-12+_l_offset-_xoff_arrow, 180, 2, 2, 180, c_white, (__sel > 1));
		draw_sprite_ext(spr_ui_arrow_flat, 0, 90+50*3+12+_l_offset+_xoff_arrow, 180, 2, 2, 0, c_white, (__sel < party_length()-2));
	}
	
	__ui_draw_top = function() {
		var roll = 80 * menuroll;
		
		draw_sprite_ext(spr_pixel, 0, 0, 0, 640, roll, 0, c_black, 1)
		draw_sprite_ext(loc_sprite("menu_label_spr"), selection, 20, 24 - 80 + roll, 2, 2, 0, c_white, 1)
	
		for (var i = 0; i < 4; ++i) {
		    draw_sprite_ext(spr_ui_menu_bt, i*2 + (selection == i ? 1 : 0), 120 + 100*i, 20 - 80 + roll, 2, 2, 0, c_white, 1)
		
			if selection == i && state == 0
				draw_sprite_ext(spr_ui_soul_small, 0, 128 + 100*i, 38 - 80 + roll, 2, 2, 0, c_red, 1)
		}
		draw_text_transformed(520, 20 - 80 + roll, string("D$ {0}", save_get("money")), 2, 2, 0)
		
		
	}
	
	__ui_draw_bottom = function(){
		var roll = 80 * menuroll;
		
		var xoff = ui_menu_x;
		if party_length() <= 3 {
			xoff = ui_menu_width*(1.5 - party_length()/2);
		}
		
		hp_bar_length = min(hp_bar_length_default, ui_menu_width - 4 - 2*party_ui_offset.edge);
	
		var _xoff_icon = party_ui_offset.edge + party_ui_offset.icon;
		var _xoff_name = _xoff_icon + party_ui_offset.name;
	
		var _xoff_hp_bar = ui_menu_width - 2 - party_ui_offset.edge - hp_bar_length;
		var _xoff_hp_text = _xoff_hp_bar - party_ui_offset.hp_bar;
	
		var _x_hp_bar_end = ui_menu_width - 2 - party_ui_offset.edge;
		
		var __xoff_hp = _x_hp_bar_end - party_ui_offset.hp;
		var __xoff_hpsep = _x_hp_bar_end - party_ui_offset.hp_sep;
		var __xoff_maxhp = _x_hp_bar_end - party_ui_offset.hp_max;
		
		draw_sprite_ext(spr_pixel, 0, 0, 417 + 80 - roll, 640, 63, 0, c_black, 1)
		
		for (var i = 0; i < party_length(); ++i) {
			
			var col = bcolor
		
			if i_pmselection == i && state == 3 && selection == 0 
				col = party_getdata(global.party_names[i], "color")
			if e_pmselection == i && selection == 1 && state > 0 
				col = party_getdata(global.party_names[i], "color")
			
			// highlight
			draw_sprite_ext(spr_pixel, 0, i*ui_menu_width + xoff, 417 + 80 - roll, ui_menu_width, 2, 0, col, 1)
			
			// icon
			if (i == i_pmselection || i_mode == 1) && state == 3 && selection == 0
				draw_sprite_ext(spr_ui_menu_heart, 0, _xoff_icon+5+ui_menu_width*i+xoff, 430+80-roll, 1, 1, 0, c_white, party_ui_alpha_icon)
			else
				draw_sprite_ext(party_get_icon(global.party_names[i]), 0, _xoff_icon+ui_menu_width*i + xoff, 430 + 80-roll, 1, 1, 0, c_white, party_ui_alpha_icon)
		
			// name
			var font = global.font_name[0]
		
			if string_length(party_getname(global.party_names[i], false)) > 4
				font = global.font_name[1]
			if string_length(party_getname(global.party_names[i], false)) > 5
				font = global.font_name[2]

			draw_set_font(font);
			
			var __name = string_upper(party_getname(global.party_names[i], false));
			
			var _text_width = string_width(__name);
			var _text_max_width = 56;
			var _text_xscale = ((_text_width > _text_max_width) ? _text_max_width/_text_width : 1);
			
	
			draw_set_alpha(party_ui_alpha_name);
			draw_text_transformed(_xoff_name + ui_menu_width*i + xoff, 430 + 80 - roll, __name, _text_xscale, 1, 0)
			draw_set_alpha(1);
			
			// hp label
			draw_set_font(global.font_ui_hp)
			draw_sprite_ext(loc_sprite("menu_caption_hp"), 0, 110 + ui_menu_width*i + xoff, 441 + 80 - roll, 1, 1, 0, c_white, party_ui_alpha_hp_text)
		
			// hp
			draw_sprite_ext(spr_pixel, 0, _xoff_hp_bar + ui_menu_width*i + xoff, 441 + 80 - roll, hp_bar_length, 9, 0, c_maroon, 1)
			draw_sprite_ext(spr_pixel, 0, _xoff_hp_bar + ui_menu_width*i + xoff, 441 + 80 - roll, hp_bar_length*(party_getdata(global.party_names[i], "hp")/party_getdata(global.party_names[i], "max_hp")), 9, 0,party_getdata(global.party_names[i], "color"), 1)
		
			draw_set_halign(fa_right)
			if party_getdata(global.party_names[i], "hp") < 30 
				draw_set_color(c_yellow)
		
			draw_text_transformed(__xoff_hp + ui_menu_width*i + xoff, 428 + 80 - roll, string(party_getdata(global.party_names[i], "hp")), 1, 1, 0)
			draw_set_alpha(party_ui_alpha_hp_num);
			draw_sprite_ext(spr_ui_hp_seperator, 0, __xoff_hpsep + ui_menu_width*i + xoff, 428 + 80 - roll, 1, 1, 0, c_white, 1)
			draw_text_transformed(__xoff_maxhp + ui_menu_width*i + xoff, 428 + 80 - roll, party_getdata(global.party_names[i], "max_hp"), 1, 1, 0)
			draw_set_alpha(1);
			
			// reactions
	        gpu_set_colourwriteenable(true, true, true, false);
			draw_set_color(c_white)
			draw_set_halign(fa_left)
			draw_set_font(loc_font("main"))
			draw_set_alpha(min(partyreactiontimer[i],1))
			draw_set_color(c_white)
		
			if is_string(partyreaction[i]) 
				draw_text_transformed(ui_menu_width*i+xoff, 456 + 80 - roll, partyreaction[i], 1, 1, 0)
			draw_set_alpha(1)
	        gpu_set_colourwriteenable(true, true, true, true);
		}
	}	
	
	// bool methods
	__draw_name = function() {
		var _ww = GAME_W_GUI / max(3, party_length());
		return (_ww > 192);
	} 
	__draw_icon = function() {
		var _ww = GAME_W_GUI / max(3, party_length());
		return (_ww > 134);
	}
	__draw_hp_label = function() {
		var _ww = GAME_W_GUI / max(3, party_length());
		return (_ww > 154 && (_ww != clamp(_ww, 192, 207)));
	}
	__draw_max_hp = function() {
		var _ww = GAME_W_GUI / max(3, party_length());
		return (_ww > 79);
	}

	__move_menu_right = function(index) {
		if party_length() > 3 {
			
			if index == party_length()-1 {
				__move_menu_first();
			}
			else if index == clamp(index, 1, party_length()-3) {
				ui_menu_x = -(index-1)*ui_menu_width;
				animate(ui_menu_x, ui_menu_x - ui_menu_width, menu_move_time, anime_curve.cubic_out, self, "ui_menu_x"); 
			}
		}
		
	}
	__move_menu_left = function(index) {
		if party_length() > 3 {
			if index == 0 {
				__move_menu_last();
			}
			else if index == clamp(index, 2, party_length()-2) {
				ui_menu_x = -(index-1)*ui_menu_width;
				animate(ui_menu_x, ui_menu_x + ui_menu_width, menu_move_time, anime_curve.cubic_out, self, "ui_menu_x"); 
			}
		}
	}
	__move_menu_to = function(index, pre_expand=true) {
		var _ww = pre_expand ? ui_menu_width_default : ui_menu_width;
		if index <= 1 {
			__move_menu_first();
		}
		else if index >= party_length()-2 {
			__move_menu_last();
		}
		else {
			animate(ui_menu_x, -(index-1)*_ww, menu_move_time, anime_curve.cubic_out, self, "ui_menu_x");
		}
	}
	__move_menu_first = function() {
		animate(ui_menu_x, 0, menu_move_time, anime_curve.cubic_out, self, "ui_menu_x");
	}
	__move_menu_last = function(pre_expand=true) {
		var _ww = pre_expand ? ui_menu_width_default : ui_menu_width;
		animate(ui_menu_x, -(party_length()-3)*_ww, menu_move_time, anime_curve.cubic_out, self, "ui_menu_x");
	}

	__party_menu_compact = function() {	
		if !party_ui_menu_compacted {
			__move_menu_first();
			
			var _ww = GAME_W_GUI / max(3, party_length());
			if party_length() > 3 {
				animate(ui_menu_width_default, _ww, compact_anim_time, anime_curve.cubic_out, self, "ui_menu_width");
				party_ui_menu_compacted = true;
			}
		
			if !__draw_name() {
				animate(party_ui_offset_default.name, 0, compact_anim_time, anime_curve.cubic_out, party_ui_offset, "name");
				animate(1, 0, compact_anim_time, anime_curve.cubic_out, self, "party_ui_alpha_name");
			}
		
			if !__draw_icon() {
				animate(party_ui_offset_default.icon, 0, compact_anim_time, anime_curve.cubic_out, party_ui_offset, "icon");
				animate(1, 0, compact_anim_time, anime_curve.cubic_out, self, "party_ui_alpha_icon");
			}
		
			if !__draw_hp_label() {
				animate(party_ui_offset_default.hp_text, 0, compact_anim_time, anime_curve.cubic_out, party_ui_offset, "hp_text");
				animate(1, 0, compact_anim_time, anime_curve.cubic_out, self, "party_ui_alpha_hp_text");
			}
		
			if !__draw_max_hp() {
				var _fnt = draw_get_font();
				draw_set_font(global.font_ui_hp);
				var _off = _ww/2 - string_width("000");
				animate(party_ui_offset.hp, _off, compact_anim_time, anime_curve.cubic_out, party_ui_offset, "hp");
				animate(1, 0, compact_anim_time, anime_curve.cubic_out, self, "party_ui_alpha_hp_num");
		
				draw_set_font(_fnt);
			}
		}
	}
	__party_menu_compact_instant = function(){
		if !party_ui_menu_compacted {
			var _ww = GAME_W_GUI / max(3, party_length());
		
			var _fnt = draw_get_font();
			draw_set_font(global.font_ui_hp);
			var _off = _ww/2 - string_width("000");
			draw_set_font(_fnt);
		
			ui_menu_width = (party_length() > 3) ? _ww : ui_menu_width_default;

			party_ui_offset.name = __draw_name()*party_ui_offset_default.name;
			party_ui_alpha_name = __draw_name();
		
			party_ui_offset.icon = __draw_icon()*party_ui_offset_default.icon;
			party_ui_alpha_icon = __draw_icon();
		
			party_ui_offset.hp_text = __draw_hp_label()*party_ui_offset_default.hp_text;
			party_ui_alpha_hp_text = __draw_hp_label();
		
			party_ui_offset.hp = !__draw_max_hp() ? _off : party_ui_offset_default.hp;
			party_ui_alpha_hp_num = __draw_max_hp();
		
			party_ui_menu_compacted = party_length() > 3;
		}
	}
	
	__party_menu_expand = function() {
		if party_ui_menu_compacted {
			if ui_menu_width != ui_menu_width_default {
				var _ww = GAME_W_GUI / max(3, party_length());
				animate(_ww, ui_menu_width_default, compact_anim_time, anime_curve.cubic_out, self, "ui_menu_width");
			}
		
			// reset name
			animate(party_ui_offset.name, party_ui_offset_default.name, compact_anim_time, anime_curve.cubic_out, party_ui_offset, "name");
			animate(party_ui_alpha_name, 1, compact_anim_time, anime_curve.cubic_out, self, "party_ui_alpha_name");

			// reset icon
			animate(party_ui_offset.icon, party_ui_offset_default.icon, compact_anim_time, anime_curve.cubic_out, party_ui_offset, "icon");
			animate(party_ui_alpha_icon, 1, compact_anim_time, anime_curve.cubic_out, self, "party_ui_alpha_icon");

			// reset hp label
			animate(party_ui_offset.hp_text, party_ui_offset_default.hp_text, compact_anim_time, anime_curve.cubic_out, party_ui_offset, "hp_text");
			animate(party_ui_alpha_hp_text, 1, compact_anim_time, anime_curve.cubic_out, self, "party_ui_alpha_hp_text");

			// reset hp
			animate(party_ui_offset.hp, party_ui_offset_default.hp, compact_anim_time, anime_curve.cubic_out, party_ui_offset, "hp");
			animate(party_ui_offset.hp_sep, party_ui_offset_default.hp_sep, compact_anim_time, anime_curve.cubic_out, party_ui_offset, "hp_sep");
			animate(party_ui_offset.hp_max, party_ui_offset_default.hp_max, compact_anim_time, anime_curve.cubic_out, party_ui_offset, "hp_max");
			animate(party_ui_alpha_hp_num, 1, compact_anim_time, anime_curve.cubic_out, self, "party_ui_alpha_hp_num");
		
			party_ui_menu_compacted = false;
		}
	}

__party_menu_compact_instant();

#endregion