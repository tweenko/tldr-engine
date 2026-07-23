if !active 
    exit;

if !surface_exists(surf)
    surf = surface_create(640, 480);

if timer % 2 == 0 {
    surface_set_target(surf);
        draw_clear(c_black);
    
        gpu_set_colorwriteenable(true, true, true, false);
    
        var _yoff_logo = (show_chapter ? -10 : 0);
        var _yoff_chtext = 15;
        
        switch state {
            case 0:
                var _logo_width = sprite_get_width(spr_intro_chapter_number);
                var _logo_height = sprite_get_height(spr_intro_chapter_number);
                
                for (var i = 0; i < sprite_height; i ++) {
                    var _x_off = factor * 40*sin(siner/5 + i/3);
                    var _x_off2 = factor * 40*sin(siner/5 + i/3 + 0.6);
                    var _x_off3 = factor * 40*sin(siner/5 + i/3 + 0.6);
                    
                    draw_sprite_part_ext(sprite_index, 0, 0, i, sprite_width, 2, (x+_x_off-sprite_width/2)*2, (y+i-sprite_height/2+_yoff_logo)*2, 2, 2, c_white, (1-factor)/2);
                    draw_sprite_part_ext(sprite_index, 0, 0, i, sprite_width, 2, (x+_x_off2-sprite_width/2)*2, (y+i-sprite_height/2+_yoff_logo)*2, 2, 2, c_white, (1-factor)/2);
                    draw_sprite_part_ext(sprite_index, 0, 0, i, sprite_width, 2, (x+_x_off3-sprite_width/2)*2, (y+i-sprite_height/2+_yoff_logo)*2, 2, 2, c_white, (1-factor)/2);	
                    
                    if show_chapter {
                        draw_sprite_part_ext(spr_intro_chapter_number, global.chapter, 0, i, _logo_width, 2, (x+_x_off-_logo_width/2)*2, (y+i+_yoff_chtext)*2, 2, 2, c_white, (1-factor)/2);
                        draw_sprite_part_ext(spr_intro_chapter_number, global.chapter, 0, i, _logo_width, 2, (x+_x_off2-_logo_width/2)*2, (y+i+_yoff_chtext)*2, 2, 2, c_white, (1-factor)/2);
                        draw_sprite_part_ext(spr_intro_chapter_number, global.chapter, 0, i, _logo_width, 2, (x+_x_off3-_logo_width/2)*2, (y+i+_yoff_chtext)*2, 2, 2, c_white, (1-factor)/2);
                    }
                }
            break;
                
            case 1:
                draw_sprite_ext(sprite_index, 0, x*2, y*2+_yoff_logo*2, 2, 2, 0, c_white, 1);
                
                if show_chapter
                    draw_sprite_ext(spr_intro_chapter_number, global.chapter, x*2, y*2+_yoff_chtext*2, 2, 2, 0, c_white, 1);
            break;
                
            case 2:
                var _min_a = min(siner/30, 0.14);
                
                draw_sprite_ext(sprite_index, 0, x*2, y*2+_yoff_logo*2, 2, 2, 0, c_white, ab);
                if show_chapter
                    draw_sprite_ext(spr_intro_chapter_number, global.chapter, x*2, y*2+_yoff_chtext*2, 2, 2, 0, c_white, ab);
                
                for (var i=0; i<10; i++) {
                    var _xoff = sin(siner/8+i/2) * i*factor2
                    var _yoff = cos(siner/8+i/2) * i*factor2
                    
                    draw_sprite_ext(sprite_index, 0, (x-_xoff)*2, (y-_yoff+_yoff_logo)*2, 2, 2, 0, c_white, _min_a*aa);
                    draw_sprite_ext(sprite_index, 0, (x+_xoff)*2, (y-_yoff+_yoff_logo)*2, 2, 2, 0, c_white, _min_a*aa);
                    draw_sprite_ext(sprite_index, 0, (x-_xoff)*2, (y+_yoff+_yoff_logo)*2, 2, 2, 0, c_white, _min_a*aa);
                    draw_sprite_ext(sprite_index, 0, (x+_xoff)*2, (y+_yoff+_yoff_logo)*2, 2, 2, 0, c_white, _min_a*aa);
                    
                    if show_chapter {
                        draw_sprite_ext(spr_intro_chapter_number, global.chapter, (x-_xoff)*2, (y-_yoff+_yoff_chtext)*2, 2, 2, 0, c_white, _min_a*aa);
                        draw_sprite_ext(spr_intro_chapter_number, global.chapter, (x+_xoff)*2, (y-_yoff+_yoff_chtext)*2, 2, 2, 0, c_white, _min_a*aa);
                        draw_sprite_ext(spr_intro_chapter_number, global.chapter, (x-_xoff)*2, (y+_yoff+_yoff_chtext)*2, 2, 2, 0, c_white, _min_a*aa);
                        draw_sprite_ext(spr_intro_chapter_number, global.chapter, (x+_xoff)*2, (y+_yoff+_yoff_chtext)*2, 2, 2, 0, c_white, _min_a*aa);
                    }
                }
                
                draw_sprite_ext(sprite_index, 1, x*2, (y+_yoff_logo)*2, 2, 2, 0, c_white, ab);
            break;
        }
    
    gpu_set_colorwriteenable(true, true, true, true);
    
    surface_reset_target();
}

draw_surface_ext(surf, 0, 0, .5, .5, 0, image_blend, image_alpha);