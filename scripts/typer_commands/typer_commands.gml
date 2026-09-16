#macro AssetTag_typer_command "TLDR_typer_command"

function typer_command() constructor {
    name = "";
    arguments = [];
    
    allow_to_advance = true;
    initial_call = undefined;
    activate = undefined;
}
function typer_command_register(_asset_index) {
    asset_add_tags(_asset_index, AssetTag_typer_command);
}

function typer_command_pause() : typer_command() constructor {
    name = ["pause", "p"];
    
    allow_to_advance = false;
    activate = function(_typer) {
        _time_source = call_later(1, time_source_units_frames, method(self, function() {
            if InputPressed(INPUT_VERB.SELECT) {
                allow_to_advance = true;
                
                if time_source_exists(_time_source)
                    call_cancel(_time_source);
                _time_source = undefined;
            }
        }), true);
    }
}
typer_command_register(typer_command_pause);

function typer_command_clear() : typer_command() constructor {
    name = ["clear", "c"];
    
    activate = function(_typer) {
        with _typer {
            symbols = [];
            parse(text);
            typewriter();
        }
    }
}
typer_command_register(typer_command_clear);

function typer_command_sleep() : typer_command() constructor {
    name = ["sleep", "s"];
    activate = method(self, function(_typer) {
        _typer._typewriter_sleep = arguments[0];
    })
}
typer_command_register(typer_command_sleep);

/// @desc finds a command by comparing names of all assets with the `AssetTag_typer_command` tag
/// @return {struct.typer_command}
function typer_command_find(_command_string) {
    var registered_commands = tag_get_asset_ids(AssetTag_typer_command, asset_script);
    for (var i = 0; i < array_length(registered_commands); i ++) {
        var cmd = new registered_commands[i]();
        
        if is_string(cmd.name) && cmd.name == _command_string
            return cmd;
        if is_array(cmd.name) && array_contains(cmd.name, _command_string)
            return cmd;
    }
    
    return undefined;
}