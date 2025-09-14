/// @description break
if break_tabulation {
	xoff = 16 * xscale
	
	if loc_getlang() == "ja" 
		xoff = string_width("＊ ") * xscale
}
else 
	xoff = 0

yoff += yspace * yscale