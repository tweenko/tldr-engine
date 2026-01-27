on = true

var longest = 0
for (var i = 2; i < array_length(choices); ++i) {
	var a = string_width(choices[i])*2
	if a > longest {
		longest = a
	}
}

xx = 320 - longest/2 - 32