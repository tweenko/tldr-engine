#macro TYPER_COMMAND_START "{"
#macro TYPER_COMMAND_END "}"

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
    
    color = c_white;
    alpha = 1;
    font = loc_font("main");
    
    spacing_mono = true;
    spacing_mono_width = 16;
    spacing_hor = 0;
    spacing_ver = 16;
    
    gui = _gui;
    
    // projections
    projections = [];
    
    /// @desc creates an `o_typer_projection` instance at the x, y and depth of the typer, which is now responsible for rendering this specific typer
    create_projection = method(self, function() {
        var _projection = instance_create(o_typer_projection, x, y, depth);
        _projection.ref = self;
        
        array_push(projections, _projection);
        
        return _projection;
    });
    /// @desc destroys all linked projections
    destroy_projections = method(self, function() {
        for (var i = 0; i < array_length(projections); i ++) {
            with projections[i] instance_destroy();
        }
    })
    
    symbols = [];
    symbols_dont_inherit = ["draw", "width", "height", "dynamic", "update_attributes"]
    symbols_dynamic = false;
    
    width = 540;
    height = undefined;
    
    fixed_width = undefined; // auto-set later, depending on whether width is defined
    fixed_height = undefined; // auto-set later, depending on whether height is defined
    break_mode = BREAK_MODE.ONLY_SPACES;
    
    dynamic = false; // if true, the info will be updated every time the typer's drawn. could be memory-heavy
    
    /// @desc the draw method for the typer. will evaluate the line breaks for you, if they weren't previously. use it to draw manually, or it will be used by a `o_typer_projection`
    draw = method(self, function() {
        // make line breaks
        if dynamic {
            line_breaks = evaluate_linebreaks();
            update_attributes(line_breaks);
        }
        
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
            
            if is_instanceof(s, typer_command) {
                // implement command drawer
            }
            else {
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
        }
        
        draw_sprite_ext(spr_pixel, 0, start_xx + width, start_yy, 1, height, 0, c_white, 1)
    });
    
    line_breaks = [];
    /// @desc should return whether a given symbol can be a start of a new line
    /// @arg {string} _symbol
    /// @return {bool}
    linebreak_rule = function(_symbol) {
        if loc_getlang() == "ja" && array_contains(TYPER_CONSIDER_SMALL_KANA, _symbol) // avoid small kana on new lines
            return false;
        
        return !__typer_symbol_is_punctuation(_symbol);
    }
    /// @desc evaluates all indices of symbols at which there should be a line break
    /// @return {array<real>}
    evaluate_linebreaks = method(self, function() {
        var line_breaks = [];
        var last_space = undefined;
        var last_space_x = 0;
        var xx_offset = break_tabulation;
        
        for (var i = 0; i < array_length(symbols); i ++) {
            var s = symbols[i];
            
            if is_instanceof(s, typer_command) {
                //
            }
            else {
                var _full_hor_spacing = (spacing_mono ? spacing_mono_width : s.width) + spacing_hor * scale_x;
                xx_offset += _full_hor_spacing;
                
                if array_contains(TYPER_CONSIDER_SPACES, s.symbol) && break_mode == BREAK_MODE.ONLY_SPACES {
                    last_space = i;
                    last_space_x = xx_offset;
                    continue;
                }
                
                // break if current length is longer than the target width
                if xx_offset >= width && !allow_overflow {
                    if break_mode == BREAK_MODE.ONLY_SPACES {
                        array_push(line_breaks, last_space);
                        last_space = i; // update last space
                        
                        xx_offset = (xx_offset - last_space_x);
                    }
                    else if break_mode == BREAK_MODE.ANY_SYMBOL {
                        var target_break_pos = i;
                        while !linebreak_rule(symbols[target_break_pos+1].symbol)
                            target_break_pos -= 1;
                        
                        // if there are more symbols ahead
                        if target_break_pos < array_length(symbols)-1 {
                            // check if the next symbol is a space, and if so, move the line break there
                            if array_contains(TYPER_CONSIDER_SPACES, symbols[target_break_pos + 1].symbol)
                                target_break_pos += 1;
                        }
                        
                        array_push(line_breaks, target_break_pos);
                        last_space = target_break_pos; // update last space
                        
                        xx_offset = 0;
                        for (var j = target_break_pos; j <= i; j ++) {
                            var _char_width = (spacing_mono ? spacing_mono_width : symbols[j].width) + spacing_hor * scale_x;
                            xx_offset += _char_width;
                        }
                    }
                    
                    xx_offset += (break_tabulation_enabled ? break_tabulation*scale_x : 0);
                }
            }
        }
        
        return line_breaks;
    })
    
    /// @desc calculates the attributes (width, height, etc.) of the typer, considering the calculated line break indices
    /// @arg {array<real>} _line_breaks
    update_attributes = method(self, function(_line_breaks = []) {
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
    
    // time callback
    time_source = undefined;
    
    /// @desc starts the text typer
    start = method(self, function() {
        parse(text);
    
        line_breaks = evaluate_linebreaks();
        update_attributes(line_breaks);
        
        // call for the first time
        method(self, callback);
        // and loop
        time_source = call_later(1, time_source_units_frames, method(self, callback), true);
    });
    /// @desc the callback (step) event of the text typer
    callback = method(self, function() {
        if _typewriter_typing {
            if _typewriter_sleep <= 0 
                && !(_typewriter_displayed_symbols < array_length(symbols) && _typewriter_displayed_symbols > 0
                    && is_instanceof(symbols[_typewriter_displayed_symbols], typer_command)
                    && !symbols[_typewriter_displayed_symbols].allow_to_advance
                ) 
            {
                repeat max(_typewriter_spd, 1) {
                    if _typewriter_displayed_symbols >= array_length(symbols) {
                        _typewriter_typing = false;
                        break;
                    }
                    
                    if _typewriter_pos >= _typewriter_displayed_symbols {
                        var s = symbols[_typewriter_displayed_symbols];
                        s.activate(self);
                        
                        _typewriter_displayed_symbols ++;
                    }
                    
                    while _typewriter_displayed_symbols < array_length(symbols) && is_instanceof(symbols[_typewriter_displayed_symbols], typer_command) && _typewriter_sleep <= 0 {
                        var s = symbols[_typewriter_displayed_symbols];
                        s.activate(self);
                        
                        if !s.allow_to_advance 
                            break;
                        
                        _typewriter_displayed_symbols ++;
                        _typewriter_pos ++;
                    }
                    
                    _typewriter_pos += _typewriter_spd;
                }
            }
            
            if _typewriter_sleep > 0
                _typewriter_sleep --;
            
            _typewriter_timer ++;
        }
    });
    /// @desc destroys the text typer (stops the time source and destroys the projection, if one exists)
    destroy = method(self, function() {
        if time_source_exists(time_source)
            call_cancel(time_source);
        time_source = undefined;
        
        destroy_projections();
    })
    
    parse_point = 1;
    /// @desc parses given text -- parses the commands, assigns them as symbols and spawns in all the symbols in advance
    parse = method(self, function(_text = text, _end_at = undefined) {
        _end_at ??= string_length(_text);
        
        while parse_point <= _end_at {
            var cur_char = string_char_at(_text, parse_point);
            
            // parse the command
            if cur_char == TYPER_COMMAND_START {
                var command_parse_result = "";
                while string_char_at(_text, parse_point) != TYPER_COMMAND_END {
                    parse_point ++;
                    command_parse_result += string_char_at(_text, parse_point);
                }
                parse_point ++;
                
                command_parse_result = string_delete(command_parse_result, string_length(command_parse_result), 1);
                
                var _cmd_name = "";
                var _cmd_args = [];
                if string_contains("(", command_parse_result) {
                    _cmd_name = string_split(command_parse_result, "(")[0];
                    
                    var args_str = string_copy(command_parse_result, string_pos("(", command_parse_result) + 1, string_pos(")", command_parse_result) - 1);
                    
                    var __temp_arg = "";
                    var __string_mode = false;
                    for (var i = 1; i <= string_length(args_str); i ++) {
                        var __char = string_char_at(args_str, i);
                        
                        if __char == "`"
                            __string_mode = !__string_mode;
                        else if __char == "," && !__string_mode {
                            __temp_arg = string_trim(__temp_arg);
                            array_push(_cmd_args, __temp_arg);
                            
                            __temp_arg = "";
                        }
                        else
                            __temp_arg += __char;
                    }
                    
                    // add the last recorded argument as well
                    if __temp_arg != "" {
                        __temp_arg = string_trim(__temp_arg);
                        array_push(_cmd_args, __temp_arg);
                    }
                }
                else
                    _cmd_name = command_parse_result;
                
                // find the command result in the command list
                var cmd = typer_command_find(_cmd_name);
                if !is_undefined(cmd) {
                    cmd.arguments = _cmd_args;
                    if !is_undefined(cmd.initial_call)
                        cmd.initial_call();
                    
                    array_push(symbols, cmd);
                    
                    if is_instanceof(cmd, typer_command_clear)
                        break;
                }
                
                continue;
            }
            
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
            
            with symbol
                update_attributes();
            
            array_push(symbols, symbol);
            
            parse_point ++;
        }
    });
    
    // typewriter method
    _typewriter_typing = false;
    _typewriter_spd = 1; // symbols that will be shown per frame. 1/2 shows a symbol once per two frames
    
    /// @desc returns how long the typewriter should pause for any given symbol
    /// @ignore
    _typewriter_calculate = function(_symbol) {
        if array_contains(TYPER_PUNCTUATION_SHORT, _symbol)
            return 10;
        else if array_contains(TYPER_PUNCTUATION_LONG, _symbol)
            return 5;
        return 0;
    }
    
    /// @desc starts the typewriter effect, which displays symbols in order of being parsed
    typewriter = method(self, function() {
        // reset the typewriter variables
        _typewriter_displayed_symbols = 0;
        _typewriter_pos = 1;
        _typewriter_sleep = 0;
        _typewriter_timer = 0;
        
        for (var i = 0; i < array_length(symbols); i ++) {
            var symbol = symbols[i];
            if !is_struct(symbol)
                exit;
            symbol.activated = false;
        }
        _typewriter_typing = true;
    })
    
    /// @desc instantly initializes all symbols, negating the typewriter method, if called.
    instant = method(self,  function() {
        for (var i = 0; i < array_length(symbols); i ++) {
            symbols[i].activate(self);
        }
        _typewriter_typing = false;
    })
    
    // misc
    /// @desc configures the current setup for a given language
    configure_for_language = method(self, function(_lang = loc_getlang()) {
        if _lang == "ja" {
            break_tabulation = 22;
            spacing_mono = false;
            break_mode = BREAK_MODE.ANY_SYMBOL;
        }
    })

    // initialize
    configure_for_language();
    start();
    typewriter();
}

function typer_symbol(_symbol) constructor {
    activated = false;
    activate = method(self, function(_typer) {
        activated = true;
    });
    
    linked_commands = [];
    
    symbol = _symbol;
    symbol_n = 0;
    font = loc_font("main");
    
    offset_x = 0;
    offset_y = 0;
    color = c_white;
    alpha = 1;
    
    shadow = true;
    shadow_x = 1;
    shadow_y = 1;
    shadow_color = c_dkgray;
    shadow_alpha = 1;
    
    scale_x = 1;
    scale_y = 1;
    angle = 0;
    align_hor = fa_left;
    align_ver = fa_middle;
    effect = TYPER_EFFECT.NONE;
    
    width = 0;
    height = 0;
    init = false;
    dynamic = false; // if it's dynamic, its info will be updated every time it's drawn
    
    draw = method(self, function(_x, _y, _angle) {
        if !activated 
            return false;
        
        // check colors
        if !is_array(color)
            color = array_create(4, color);
        else if array_length(color) == 1
            color = array_create(4, color[0]);
        else if array_length(color) == 2 
            color = [color[0], color[0], color[1], color[1]];
        else if array_length(color) == 3
            array_push(color, color[2]);
        
        if !is_array(shadow_color)
            shadow_color = array_create(4, shadow_color);
        else if array_length(color) == 1
            shadow_color = array_create(4, shadow_color[0]);
        else if array_length(shadow_color) == 2 
            shadow_color = [shadow_color[0], shadow_color[0], shadow_color[1], shadow_color[1]];
        else if array_length(shadow_color) == 3
            array_push(shadow_color, shadow_color[2]);
        
        // update info
        if dynamic || !init {
            update_attributes();
            if !init
                init = true;
        }
        
        draw_set_font(font);
        
        var __offset_hor = lengthdir_x(offset_x, _angle - 90) + lengthdir_x(offset_y, _angle - 90);
        var __offset_ver = lengthdir_y(offset_x, _angle - 90) + lengthdir_y(offset_y, _angle - 90);
        
        if shadow {
            draw_text_transformed_colour(
                _x + __offset_hor + shadow_x, 
                _y + __offset_ver + shadow_x, 
                symbol, 
                scale_x, scale_y, _angle + angle,
                shadow_color[0], shadow_color[1], shadow_color[2], shadow_color[3],
                shadow_alpha
            );
        }
        draw_text_transformed_colour(
            _x + __offset_hor, 
            _y + __offset_ver, 
            symbol, 
            scale_x, scale_y, _angle + angle,
            color[0], color[1], color[2], color[3],
            alpha
        );
    });
    update_attributes = method(self, function() {
        var font_og = draw_get_font();
        draw_set_font(font);
        
        width = string_width(symbol) * scale_x;
        height = string_height(symbol) * scale_y;
        
        draw_set_font(font_og);
    });
    
    time_source = undefined;
    start = method(self, function() {
        // call for the first time
        method(self, callback);
        // and loop
        time_source = call_later(1, time_source_units_frames, method(self, callback), true);
    })
    callback = method(self, function() {
        if !activated 
            return false;
        
        if effect == TYPER_EFFECT.WAVE
            offset_y = sine(5, 2, o_world.frames + symbol_n*3);
    });
    destroy = method(self, function() {
        if time_source_exists(time_source)
            call_cancel(time_source);
        time_source = undefined;
        
        return false;
    })
    
    update_attributes();
    start();
}

enum TYPER_EFFECT {
    NONE,
    SHAKE,
    WAVE
}
enum BREAK_MODE {
    ONLY_SPACES,
    ANY_SYMBOL
}