function typer(_text, _x, _y, _depth, _gui = true) constructor {
    text = _text;
    
    x = _x;
    y = _y;
    depth = _depth;
    
    scale_x = 2;
    scale_y = 2;
    angle = 0;
    align_hor = fa_left;
    align_ver = fa_top;
    allow_overflow = false;
    break_tabulation = 16;
    break_tabulation_enabled = true;
    
    color = [c_white, c_yellow];
    alpha = 1;
    font = loc_font("main");
    
    spacing_mono = true;
    spacing_mono_width = 16;
    spacing_hor = 0;
    spacing_ver = 16;
    
    gui = _gui;
    
    projection = noone;
    create_projection = method(self, function() {
        projection = instance_create(o_typer_projection, x, y, depth);
        projection.ref = self;
        return projection;
    });
    destroy_projection = method(self, function() {
        instance_destroy(projection);
    })
    
    symbols = [];
    symbols_dont_inherit = ["draw", "width", "height", "dynamic", "update_info"]
    symbols_dynamic = false;
    
    width = 540;
    height = undefined;
    fixed_width = undefined; // auto-set later
    fixed_height = undefined; // auto-set later
    
    dynamic = true; // if true, the info will be updated every time the typer's drawn. could be memory-heavy
    
    draw = method(self, function() {
        // make line breaks
        var line_breaks = evaluate_linebreaks();
        
        if dynamic
            update_info(line_breaks);
        
        var xx = x;
        var yy = y;
        
        if align_hor == fa_center
            xx -= width/2;
        else if align_hor == fa_right 
            xx -= width;
        
        if align_ver == fa_middle 
            yy -= height/2;
        else if align_ver == fa_bottom
            yy -= height;
        
        var start_xx = xx;
        var start_yy = yy;
        
        for (var i = 0; i < array_length(symbols); i ++) {
            var s = symbols[i];
            
            var _dx = xx - x;
            var _dy = yy - y;
            
            s.draw(
                x + lengthdir_x(_dx, angle) + lengthdir_x(_dy, angle - 90), 
                y + lengthdir_y(_dx, angle) + lengthdir_y(_dy, angle - 90), 
                angle,
            );
            
            var _full_hor_spacing = (spacing_mono ? spacing_mono_width : s.width) + spacing_hor * scale_x;
            xx += _full_hor_spacing;
            
            if array_contains(line_breaks, i) {
                xx = start_xx;
                xx += (break_tabulation_enabled ? break_tabulation*scale_x : 0);
                
                yy += spacing_ver * scale_y;
            }
        }
        
        draw_sprite_ext(spr_pixel, 0, start_xx + width, start_yy, 1, height, 0, c_white, 1)
    });
    
    parse = method(self, function(_text) {
        var parse_point = 1;
        
        while parse_point <= string_length(_text) {
            var cur_char = string_char_at(_text, parse_point);
            var symbol = new typer_symbol(cur_char);
            
            // inherit all struct variables
            var struct_names = struct_get_names(self);
            for (var i = 0; i < array_length(struct_names); i ++) {
                if !struct_exists(symbol, struct_names[i]) || array_contains(symbols_dont_inherit, struct_names[i])
                    continue;
                
                struct_set(symbol, struct_names[i], struct_get(self, struct_names[i]));
            }
            
            // inherit the other ones manually for naming conventions' sake
            symbol.dynamic = symbols_dynamic;
            symbol.symbol_n = parse_point - 1;
            
            array_push(symbols, symbol);
            
            parse_point ++;
        }
    });
    update_info = method(self, function(_line_breaks = []) {
        var cumulative_width = [0];
        var cumulative_height = 0;
        var line_n = 1;
        
        for (var i = 0; i < array_length(symbols); i ++) {
            var _full_hor_spacing = (spacing_mono ? spacing_mono_width : symbols[i].width) + spacing_hor * scale_x;
            array_resize(cumulative_width, line_n);
            cumulative_width[line_n - 1] += _full_hor_spacing;
            
            if array_contains(_line_breaks, i)
                line_n ++;
        }
        
        cumulative_height = line_n * spacing_ver * scale_y;
        
        fixed_width ??= !is_undefined(width);
        fixed_height ??= !is_undefined(height);
        
        if !fixed_width
            width = array_sort(cumulative_width, false)[0];
        if !fixed_height
            height = cumulative_height;
    })
    evaluate_linebreaks = method(self, function() {
        var line_breaks = [];
        var last_space = undefined;
        var last_space_x = 0;
        var xx_offset = 0;
        for (var i = 0; i < array_length(symbols); i ++) {
            var s = symbols[i];
            
            var _full_hor_spacing = (spacing_mono ? spacing_mono_width : s.width) + spacing_hor * scale_x;
            xx_offset += _full_hor_spacing;
            
            if s.symbol == " " {
                last_space = i;
                last_space_x = xx_offset;
                continue;
            }
            
            // break if current length is longer than the target width
            if xx_offset >= width {
                array_push(line_breaks, last_space);
                
                last_space = i;
                
                xx_offset = (xx_offset - last_space_x);
                xx_offset += (break_tabulation_enabled ? break_tabulation*scale_x : 0);
            }
        }
        
        return line_breaks;
    })
    
    time_source = undefined;
    start = method(self, function() {
        // call for the first time
        method(self, callback);
        // and loop
        time_source = call_later(1, time_source_units_frames, method(self, callback), true);
    })
    callback = method(self, function() {
        width = 500 + sine(20, 100);
    });
    destroy = method(self, function() {
        if time_source_exists(time_source)
            call_cancel(time_source);
        time_source = undefined;
        
        destroy_projection();
        return false;
    })
    
    parse(text);
    update_info();
    start();
}

function typer_symbol(_symbol) constructor {
    symbol = _symbol;
    symbol_n = 0;
    font = font_main;
    
    offset_x = 0;
    offset_y = 0;
    scale_x = 1;
    scale_y = 1;
    angle = 0;
    align_hor = fa_left;
    align_ver = fa_middle;
    effect = TYPER_EFFECT.NONE;
    
    alpha = 1;
    color = c_white;
    
    width = 0;
    height = 0;
    init = false;
    dynamic = false; // if it's dynamic, its info will be updated every time it's drawn
    
    draw = method(self, function(_x, _y, _angle) {
        // check colors
        if !is_array(color)
            color = array_create(4, color);
        else if array_length(color) == 1
            color = [color[0], color[0], color[0], color[0]];
        else if array_length(color) == 2 
            color = [color[0], color[0], color[1], color[1]];
        else if array_length(color) == 3
            array_push(color, color[2]);
        
        // update info
        if dynamic || !init {
            update_info();
            if !init
                init = true;
        }
        
        draw_set_font(font);
        
        var __offset_hor = lengthdir_x(offset_x, _angle - 90) + lengthdir_x(offset_y, _angle - 90);
        var __offset_ver = lengthdir_y(offset_x, _angle - 90) + lengthdir_y(offset_y, _angle - 90);
        
        draw_text_transformed_colour(
            _x + __offset_hor, 
            _y + __offset_ver, 
            symbol, 
            scale_x, scale_y, _angle + angle,
            color[0], color[1], color[2], color[3],
            alpha
        );
    });
    update_info = method(self, function() {
        width = string_width(symbol) * scale_x;
        height = string_height(symbol) * scale_y;
    });
    
    time_source = undefined;
    start = method(self, function() {
        // call for the first time
        method(self, callback);
        // and loop
        time_source = call_later(1, time_source_units_frames, method(self, callback), true);
    })
    callback = method(self, function() {
        if effect == TYPER_EFFECT.WAVE
            offset_y = sine(5, 2, o_world.frames + symbol_n*3);
    });
    destroy = method(self, function() {
        if time_source_exists(time_source)
            call_cancel(time_source);
        time_source = undefined;
        
        return false;
    })
    
    update_info();
    start();
}

enum TYPER_EFFECT {
    NONE,
    SHAKE,
    WAVE
}