/// @description predict text
var w = 515
var manualbreaks = []
var twb = text

if caller.object_index == o_ui_enemydialogue // make the width smaller for battles
	w = 174

linebreaks = []

maxw = 0
maxh = 0

draw_set_font(font)

// account for the clears as dialogue breaks
if string_contains("{c}", twb) {
	for (var i = 0; i < string_length(twb)-2; ++i) {
	    if string_char_at(twb, i) == "{"
			&& string_char_at(twb, i + 1) == "c"
			&& string_char_at(twb, i + 2) == "}" 
		{
			twb = string_copy(twb, 0, i-1)
			break
		}
	}
}
// remove other commands and account for manual breaks
while string_contains("{", twb) {
	if string_copy(twb, string_pos("{", twb), string_pos("}", twb) - string_pos("{", twb) + 1) == "{br}"{
		array_push(manualbreaks, string_pos("{br}", twb) - 1)
	}
	twb = string_delete(twb, string_pos("{", twb), string_pos("}", twb)-string_pos("{", twb) + 1)
}

// don't predict text
if !predict_text {
    linebreaks = manualbreaks
	exit
}

var stringsofar = ""
var lastreservedspace = 0
var widthcutter = 0
var lastbreak = 0

// do manual and auto breaks
for (var i = 0; i < string_length(twb); ++i) {
	if array_contains(manualbreaks, i) {
		stringsofar = "";
		widthcutter = 16 * xscale
		if loc_getlang() == "ja" 
			widthcutter = string_width("＊ ") * xscale
	}
    stringsofar += string_char_at(twb,i)
	
	if string_char_at(twb, i) == "*" && string_char_at(twb,i + 1) == " "
		widthcutter = 0
	if string_char_at(twb, i) == " "
		lastreservedspace = i
	
	if string_width(stringsofar) * xscale > (w-widthcutter) - (x-xstart){
		if lastreservedspace < 3 { // make sure we don't do breaks on the asterisk part
			stringsofar = ""
			array_push(linebreaks, i)
			lastbreak = i
		}
		else {
			stringsofar = string_copy(twb,lastreservedspace,i-lastreservedspace)
			array_push(linebreaks, lastreservedspace + disp_chars)
			lastbreak = lastreservedspace + disp_chars
		}
		
		lastreservedspace = 0
	}
}

var strformatted = twb
var allbreaks = array_concat(linebreaks, manualbreaks)
for (var i = 0; i < array_length(allbreaks); ++i) {
	var spaces = ""
	
	strformatted = string_delete(strformatted, allbreaks[i], 1)
    strformatted = string_insert("\n", strformatted, allbreaks[i])
}
	
linebreaks = allbreaks
maxw = string_width(strformatted) * xscale
maxh = (array_length(linebreaks) + 1) * yspace * yscale
if maxw == 0 {
	maxw = string_width(twb) * xscale
}
        
x -= center_xoff
y -= center_yoff
        
if instance_exists(caller) {
	if center_x {
		x -= maxw/2
        center_xoff = -maxw/2
    }
	if center_y {
		y -= maxh/2
        center_yoff = -maxh/2
    }
	
	// make the enemy dialogue centered right-center
	if caller.object_index == o_ui_enemydialogue {
		x -= maxw/2
        center_xoff += -maxw/2
    }
}