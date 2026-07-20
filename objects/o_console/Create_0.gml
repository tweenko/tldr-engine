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