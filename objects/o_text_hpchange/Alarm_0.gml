if mode == 3 || mode == 4 {
	var a = animate(.1, 1.5, 6, anime_curve.quad_out, id, "stretch", false)
        a._add(1, 4, anime_curve.linear)
        a._start()
	
    var b = animate(60, -6, 6, anime_curve.linear, id, "xoff", false)
        b._add(6, 4, anime_curve.linear)
        b._start()
}
else {
    animate(x - 6, x - 6 + 15, 10, anime_curve.linear, id, "x")
    animate(y - 14, y + 6, 20, anime_curve.bounce_out, id, "y")
    animate(.2, 1, 3, anime_curve.linear, id, "stretch")
}

alarm[1] = 30