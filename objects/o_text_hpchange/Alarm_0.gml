if mode == 3 || mode == 4 {
	var a = create_anime(.1)
		.add(1.5, 6, "quad_out")
		.add(1, 4, "linear")
		.start(function(v){
			id.stretch = v
		})
	
	a = create_anime(60)
		.add(-6, 6, "linear")
		.add(6, 4, "linear")
		.start(function(v){
			id.xoff = v
		})
}
else {
	do_anime(x - 6, x - 6 + 15, 10, "linear", function(v) {
		if instance_exists(id) 
			id.x = v
	})
	do_anime(y - 14, y + 6, 20, "bounce_out", function(v) {
		if instance_exists(id) 
			id.y = v
	})
	do_anime(.2, 1, 3, "linear", function(v) {
		if instance_exists(id) 
			id.stretch = v
	})
}

alarm[1] = 30