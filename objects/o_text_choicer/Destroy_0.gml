if instance_exists(caller) && caller.object_index == o_text_typer {
    caller.pause = 4;
    caller.allow_skip_internal = caller.choice_save_allow_skip;
}
else 
    instance_destroy(caller);

global.temp_choice = selection;