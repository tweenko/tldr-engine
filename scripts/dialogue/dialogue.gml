/// @desc creates an `o_ui_dialogue` instance with set parameters
/// @arg {array<string>,string} text could be either an array or just a string. if it's an array, between the array entries the box will pause and clear itself afterwards.
/// @arg {bool} destroy_other_instances whether the dialogue should destroy the other already existing dialogue instances before spawning itself
/// @arg {bool} allow_movement whether the player can move or not during the dialogue
function dialogue_start(text, _destroy_other_instances = true, allow_movement = false) {
    if _destroy_other_instances
        instance_destroy(o_ui_dialogue)
    
	var inst = instance_create(o_ui_dialogue)
	inst.text = dialogue_array_to_string(text)
    
    get_leader().moveable_dialogue = allow_movement
	
	return inst
}

///@arg {array<string>, string} arr
function dialogue_array_to_string(arr) {
	if is_string(arr) 
		return arr
	
	var str = ""
	for (var i = 0; i < array_length(arr); ++i) {
	    str += arr[i]
		if i < array_length(arr)-1 
			str += "{p}{c}"
	}
	return str
}

/// @desc constructor for text typer choices
/// @arg {string|function} _text the typer choice text. can be callable
/// @arg {real|function} _off_x adjustment on the choice's default x position. can be callable
/// @arg {real|function} _off_y adjustment on the choice's default y position. can be callable
/// @arg {Constant.Colour|function} _color the color of the choice. can be callable
/// @arg {Constant.Colour|function} _select_color the color of the choice when selected. can be callable
function text_typer_choice(_text, _off_x = 0, _off_y = 0, _color = c_white, _select_color = c_yellow) constructor {
    text = _text;
    color = _color;
    select_color = _select_color;
    off_x = _off_x;
    off_y = _off_y;
    
    _draw = function(_x, _y, _pos, _choicer, _halign = fa_left) {
        var __t = variable_callable_to_value(text);
        
        if _halign == fa_right 
            _x -= string_width(__t)*2;
        else if _halign == fa_center
            _x -= string_width(__t);
        
        _x += variable_callable_to_value(off_x);
        _y += variable_callable_to_value(off_y);
        
        draw_set_colour(variable_callable_to_value(color));
        
        if _choicer.selection == _pos {
            draw_set_color(variable_callable_to_value(select_color));
            _choicer.target_x = _x - 32;
            _choicer.target_y = _y + 10;
        }
        draw_text_transformed(_x, _y, __t, 2, 2, 0);
        
        draw_set_colour(c_white);
    }
};

/// @desc starts a choicer and creates a dialogue box for it if needed
/// @arg {struct.text_typer_choice|string} _choices the choices given in the choicer
/// @arg {id.instance} _caller the caller (an instance of `o_ui_dialogue`)
/// @arg {bool} _box_pos_down whether the box should be on the bottom. by default equals to `undefined`, which makes it automatically pick the optimal position
function text_typer_choicer(_choices, _caller = id, _box_pos_down = undefined) {
    for (var i = 0; i < array_length(_choices); i ++) {
        if is_instanceof(_choices[i], text_typer_choice) || is_struct(_choices[i])
            continue;
        _choices[i] = new text_typer_choice(_choices[i]);
    }
    
    var inst_dialogue = ((instance_exists(_caller) && _caller.object_index == o_ui_dialogue) ? _caller : instance_nearest(0, 0, o_ui_dialogue));
    if !instance_exists(inst_dialogue) {
        inst_dialogue = instance_create(o_ui_dialogue);
        if !is_undefined(_box_pos_down)
            inst_dialogue._reposition_self_to(_box_pos_down);
        
        with inst_dialogue event_user(0);
    }
    
    var xx = inst_dialogue.xx + 26;
    var yy = inst_dialogue.yy + 20;
    if inst_dialogue.encounter_mode {
        xx = 30; 
        yy = 376;
    }
    else if inst_dialogue.shop_mode {
        xx = 30; 
        yy = 270;
    };
    
    var choicer = instance_create(o_text_choicer, xx, yy, inst_dialogue.depth - 10, {
        choices: _choices,
        caller: inst_dialogue,
        box_height: 151
    });
    
    return choicer;
    
    
}