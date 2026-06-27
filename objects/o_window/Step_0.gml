if global.border {
    if is_struct(global.border_struct) && is_method(global.border_struct._step)
        global.border_struct._step();
}