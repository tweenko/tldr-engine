name = "looping choicer";

target_memory_category = "choicer_test_01";
choice_pool = [
    "Option 1",
    "Option 2",
    undefined,
    "Return"
];

available_choices = variable_clone(choice_pool);
for (var i = 0; i < array_length(available_choices); i ++) {
    if memory_get(target_memory_category, i) {
        array_set(available_choices, i, new __text_typer_choice_asked());
        available_choices[2] ??= new __text_typer_choice_reset();
    }
}

function __text_typer_choice_asked() : text_typer_choice("(Unavailable)",,, c_gray, c_gray, false) constructor {};
function __text_typer_choice_reset() : text_typer_choice("Reset",,, merge_colour(c_white, c_blue, .5), c_aqua) constructor {};

execute_code = method(self, function() {
    cutscene_create();
    cutscene_player_canmove(false);
    cutscene_choicer(available_choices);
    
    cutscene_func(method(self, function() {
        if global.temp_choice == 2 { // reset
            for (var i = 0; i < array_length(available_choices); i ++) {
                memory_set(target_memory_category, i, false);
            };
            available_choices = variable_clone(choice_pool);
            
            cutscene_create();
            cutscene_audio_play(snd_egg);
            cutscene_dialogue("* (The choicer's memory was reset.)");
            
            cutscene_func(execute_code);
            
            cutscene_play();
        }
        else if global.temp_choice == 3 { // return
            get_leader().moveable = true; // leader can only start moving if return was pressed. no other conditions to account for, so it can be hard-coded like this LOL
        }
        else { // continue looping or whatever
            cutscene_create();
            cutscene_dialogue("* (You chose " + available_choices[global.temp_choice].text + "! It's no longer available in the choicer.)");
            cutscene_func(execute_code);
            cutscene_play();
            
            available_choices[global.temp_choice] = new __text_typer_choice_asked();
            memory_set(target_memory_category, global.temp_choice, true);
            
            // add reset if we don't have it
            available_choices[2] ??= new __text_typer_choice_reset();
        };
    }));
    cutscene_play();
});