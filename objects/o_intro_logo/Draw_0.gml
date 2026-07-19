if active {
	var _yoff_logo = -show_chapter*10;
	var _yoff_chtext = 15;
	
	switch(state) {
		case 0: {
			siner++;
			factor -= 0.003 + siner/900;
			
			if factor < 0 {
				factor = 0;
				
				call_later(31, time_source_units_frames, method(o_intro_logo, function() {
					state = 2;
					siner = 0;
				}), false)
				
				state++;
			}
			
			for (var i=0; i<sprite_height; i++) {
				var _x_off = factor * 40*sin(siner/5 + i/3);
				var _x_off2 = factor * 40*sin(siner/5 + i/3 + 0.6);
				var _x_off3 = factor * 40*sin(siner/5 + i/3 + 0.6);
				
				draw_sprite_part_ext(sprite_index, 0, 0, i, sprite_width, 2, x+_x_off-sprite_width/2, y+i-sprite_height/2+_yoff_logo, 1, 1, c_white, (1-factor)/2);
				draw_sprite_part_ext(sprite_index, 0, 0, i, sprite_width, 2, x+_x_off2-sprite_width/2, y+i-sprite_height/2+_yoff_logo, 1, 1, c_white, (1-factor)/2);
				draw_sprite_part_ext(sprite_index, 0, 0, i, sprite_width, 2, x+_x_off3-sprite_width/2, y+i-sprite_height/2+_yoff_logo, 1, 1, c_white, (1-factor)/2);	
			}
			
			var _wch = sprite_get_width(spr_intro_logo_chapter);
			var _hch = sprite_get_height(spr_intro_logo_chapter);
			
			if show_chapter {
				for (var i=0; i<_hch; i++) {
					var _x_off = factor * 40*sin(siner/5 + i/3);
					var _x_off2 = factor * 40*sin(siner/5 + i/3 + 0.6);
					var _x_off3 = factor * 40*sin(siner/5 + i/3 + 0.6);
					
					draw_sprite_part_ext(spr_intro_logo_chapter, global.chapter, 0, i, _wch, 2, x+_x_off-_wch/2, y+i+_yoff_chtext, 1, 1, c_white, (1-factor)/2);
					draw_sprite_part_ext(spr_intro_logo_chapter, global.chapter, 0, i, _wch, 2, x+_x_off2-_wch/2, y+i+_yoff_chtext, 1, 1, c_white, (1-factor)/2);
					draw_sprite_part_ext(spr_intro_logo_chapter, global.chapter, 0, i, _wch, 2, x+_x_off3-_wch/2, y+i+_yoff_chtext, 1, 1, c_white, (1-factor)/2);
				}
			}
		}
			break;
			
		case 1: {
			draw_sprite(sprite_index, 0, x, y+_yoff_logo);
			
			if show_chapter {
				draw_sprite(spr_intro_logo_chapter, global.chapter, x, y+_yoff_chtext);
			}
		}
			break;
			
		case 2: {
			var _min_a = min(siner/30, 0.14);
			siner += 0.5;
			
			phaseplus = (siner >= 20);
			
			if phaseplus {
				aa -= 0.02;
				ab -= 0.08;
			}
			
			factor2 += 0.05;
			
			draw_sprite_ext(sprite_index, 0, x, y+_yoff_logo, 1, 1, 0, c_white, ab);
			if show_chapter {
				draw_sprite_ext(spr_intro_logo_chapter, global.chapter, x, y+_yoff_chtext, 1, 1, 0, c_white, ab);
			}
			
			for (var i=0; i<10; i++) {
				var _xoff = sin(siner/8+i/2) * i*factor2
				var _yoff = cos(siner/8+i/2) * i*factor2
				
				draw_sprite_ext(sprite_index, 0, x-_xoff, y-_yoff+_yoff_logo, 1, 1, 0, c_white, _min_a*aa);
				draw_sprite_ext(sprite_index, 0, x+_xoff, y-_yoff+_yoff_logo, 1, 1, 0, c_white, _min_a*aa);
				draw_sprite_ext(sprite_index, 0, x-_xoff, y+_yoff+_yoff_logo, 1, 1, 0, c_white, _min_a*aa);
				draw_sprite_ext(sprite_index, 0, x+_xoff, y+_yoff+_yoff_logo, 1, 1, 0, c_white, _min_a*aa);
				
				if show_chapter {
					draw_sprite_ext(spr_intro_logo_chapter, global.chapter, x-_xoff, y-_yoff+_yoff_chtext, 1, 1, 0, c_white, _min_a*aa);
					draw_sprite_ext(spr_intro_logo_chapter, global.chapter, x+_xoff, y-_yoff+_yoff_chtext, 1, 1, 0, c_white, _min_a*aa);
					draw_sprite_ext(spr_intro_logo_chapter, global.chapter, x-_xoff, y+_yoff+_yoff_chtext, 1, 1, 0, c_white, _min_a*aa);
					draw_sprite_ext(spr_intro_logo_chapter, global.chapter, x+_xoff, y+_yoff+_yoff_chtext, 1, 1, 0, c_white, _min_a*aa);
				}
			}
			
			draw_sprite_ext(sprite_index, 1, x, y+_yoff_logo, 1, 1, 0, c_white, ab);

			if aa <= -0.46 {
				event_perform(ev_room_end, 0);
			}
			
			if aa < -0.5 && !skipped {
				room_goto(room_save_select);
			}
		}
			break;
	}
}

if InputCheck(INPUT_VERB.SELECT) && !skipped {
	skipped = true;
	
	fader_fade(0, 1, 25);
	music_fade(0, 0, 40);
	
	cutscene_create();
	
	cutscene_sleep(28);
	cutscene_func(method(o_intro_logo, event_perform), [ev_room_end, 0]);
	cutscene_sleep(2);
	cutscene_func(__init);
	cutscene_func(room_goto, room_save_select);
	
	cutscene_play();
}

