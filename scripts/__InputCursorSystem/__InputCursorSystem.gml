// Feather disable all

#macro __INPUT_VALIDATE_CURSOR_CLUSTER if (INPUT_SAFETY_CHECKS)\
                                     {\
                                         if (not is_numeric(INPUT_CURSOR_CLUSTER))\
                                         {\
                                             __InputError("Cursor cluster index must be a number (typeof = \"", typeof(INPUT_CURSOR_CLUSTER), "\")");\
                                         }\
                                         if (INPUT_CURSOR_CLUSTER < 0)\
                                         {\
                                             __InputError("Cursor cluster index ", INPUT_CURSOR_CLUSTER, " less than zero");\
                                         }\
                                     }

__InputCursorSystem();
function __InputCursorSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {};
    with(_system)
    {
        __playerArray = array_create_ext(INPUT_MAX_PLAYERS, function(_index)
        {
            return new __InputCursorClassPlayer(_index);
        });
        
        InputPlugInDefine("InputTeam.Cursor", "Input Team", "1.1", "10.3", function()
        {
            if (INPUT_CURSOR_CLUSTER < 0)
            {            
                InputPlugInWarning("Invalid cursor cluster index (", INPUT_CURSOR_CLUSTER, ")");
            }
            else
            {
                InputPlugInRegisterCallback(INPUT_PLUG_IN_CALLBACK.UPDATE, -1, function()
                {
                    var _i = 0;
                    repeat(INPUT_MAX_PLAYERS)
                    {
                        __playerArray[_i].__Update();
                        ++_i;
                    }
                });
            }
        });
    }
    
    return _system;
}