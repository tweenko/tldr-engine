if visible {
	if InputPressed(INPUT_VERB.LEFT) && array_length(choices) > 0 && !is_undefined(choices[0])
		selection = 0;
	if InputPressed(INPUT_VERB.RIGHT) && array_length(choices) > 1 && !is_undefined(choices[1])
		selection = 1;
	if InputPressed(INPUT_VERB.UP) && array_length(choices) > 2 && !is_undefined(choices[2])
		selection = 2;
	if InputPressed(INPUT_VERB.DOWN) && array_length(choices) > 3 && !is_undefined(choices[3])
		selection = 3;

	if InputPressed(INPUT_VERB.SELECT) && selection != -1 {
        var choice = choices[selection];
        if variable_callable_to_value(choice.can_select)
            instance_destroy();
    }
    
    soul_x = lerp(soul_x, target_x, .8);
    soul_y = lerp(soul_y, target_y, .8);
}