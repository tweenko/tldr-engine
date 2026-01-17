inst = text_typer_create(text, x+8-20 + (side == -1 ? 30 : 0), y+4, depth-10, preset, "", {
	caller: id, 
	gui: true,
	destroy_caller: true,
	center_y: true,
    max_width: max_typer_width
})