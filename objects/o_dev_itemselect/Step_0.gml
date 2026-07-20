event_inherited();

if selection_prev != selection {
    hover_timer = 0;
    hovered_item = undefined;
}
else if category >= 0 
    && category < array_length(display_list) 
    && selection >= 0 
    && selection < array_length(display_list[category].items) 
{
    hover_timer ++;
    
    if hover_timer > 3 && is_undefined(hovered_item) && is_callable(display_list[category].items[selection]) {
        hovered_item = new display_list[category].items[selection]();
    }
}
    
selection_prev = selection;