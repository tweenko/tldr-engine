inst = instance_create(o_text_typer, x+8-20, y+4, depth-10, {
	text: preset + text + "{p}{e}", 
	caller: id, 
	gui: true,
	destroy_caller: true,
	center_y: true,
})