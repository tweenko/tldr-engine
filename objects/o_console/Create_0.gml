active = false
console_caller = function() {
	return keyboard_check_pressed(vk_tab)
}

registred_commands = tag_get_asset_ids(AssetTag_command, asset_script);
for (var i = 0; i < array_length(registred_commands); i ++) {
    registred_commands[i] = new registred_commands[i]();
    if !is_array(registred_commands[i].hotkey)
        registred_commands[i].hotkey = [registred_commands[i].hotkey];
}

depth = DEPTH_UI.CONSOLE;

keyhold = 0;
keyhold_max = 10;

held_keys = [];
curcommand = function() {};
current_console_logs = array_create(4, undefined);

/// @arg {struct.console_log} _log
log = method(self, function(_log) {
    array_insert_cycle(current_console_logs, 0, _log);
})
/// @arg {string} _text
/// @arg {Constant.Color} _color the color here will be merged with white (half-and-half). to override this, set the color attribute manually
log_text = method(self, function(_text, _color = c_white) {
    var _log = new console_log(_text);
    _log.color = merge_colour(_color, c_white, .5);
    array_insert_cycle(current_console_logs, 0, _log);
})

command_find = function(_hotkey) {
    for (var i = 0; i < array_length(registred_commands); i ++) {
        if array_equals(registred_commands[i].hotkey, _hotkey)
            return registred_commands[i];
    }
    return undefined;
}
get_all_pressed_keys = function() {
    var keys = [];
    for (var i = ord("!"); i < ord("`"); i ++) {
        if keyboard_check(i)
            array_push(keys, i);
    }
    return keys;
}