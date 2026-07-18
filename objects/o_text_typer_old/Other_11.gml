/// @description predict text
var w = max_width
var manualbreaks = []
var twb = text

linebreaks = []
width = 0
height = 0

draw_set_font(font)

// initialize the break x offsets
switch break_system { // then scaled by the scale_x factor
    default:
        break_xoff = string_width("* ")
        break
    case "ja":
        break_xoff = string_width("＊ ")
        break
}

// account for the clears as dialogue breaks
if string_contains("{c}", twb) {
	for (var i = 0; i < string_length(twb); ++i) {
	    if string_char_at(twb, i) == "{"
			&& string_char_at(twb, i + 1) == "c"
			&& string_char_at(twb, i + 2) == "}" 
		{
			twb = string_copy(twb, 1, i-1)
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
if !predict_text || !auto_breaks {
    linebreaks = manualbreaks
	exit
}

var stringsofar = ""
var lastreservedspace = 0
var widthcutter = 0
var lastbreak = 0

// do manual and auto breaks
for (var i = 1; i <= string_length(twb); ++i) {
	if array_contains(manualbreaks, i - 1) {
		stringsofar = "";
		widthcutter = break_xoff * xscale
	}
    stringsofar += string_char_at(twb, i)
	
	if (string_char_at(twb, i) == "*" && string_char_at(twb, i + 1) == " "
    || string_char_at(twb, i) == "＊" && string_char_at(twb, i + 1) == " ")
    || !break_tabulation 
		widthcutter = 0
    
	if string_char_at(twb, i) == " " && break_system != "ja"
		lastreservedspace = i
	
	if string_width(stringsofar) * xscale >= (w - widthcutter) - center_xoff - face_xoff {
		if lastreservedspace < 3 { // make sure we don't do breaks on the asterisk part (or this is japanese)
			while string_char_at(twb, i+1) == " " || string_char_at(twb, i+1) == "　"
                i ++
            
            stringsofar = ""
			array_push(linebreaks, i)
			lastbreak = i
		}
		else {
			stringsofar = string_copy(twb, lastreservedspace, i-lastreservedspace)
			array_push(linebreaks, lastreservedspace + disp_chars)
			lastbreak = lastreservedspace + disp_chars
		}
		
        widthcutter = break_xoff * xscale
		lastreservedspace = 0
	}
}

var strformatted = twb
var allbreaks = array_concat(linebreaks, manualbreaks)
for (var i = 0; i < array_length(allbreaks); ++i) { // add \n to the string to format it
	strformatted = string_delete(strformatted, allbreaks[i], 1)
    strformatted = string_insert("\n", strformatted, allbreaks[i])
}
        
var line_longest_txt = 0
var line_longest_width = 0
var __all_lines = string_split(strformatted, "\n")
for (var i = 0; i < array_length(__all_lines); ++i) { // add \n to the string to format it
	var curw = string_width(__all_lines[i])
    if curw > line_longest_width {
        line_longest_width = curw
        line_longest_txt = __all_lines[i]
    }
}
	
linebreaks = allbreaks

width = line_longest_width * xscale
width += string_length(line_longest_txt) * xspace * xscale // add the xspace
        
height = (array_length(linebreaks) + 1) * yspace * yscale

if width == 0 {
	width = string_width(twb) * xscale
}
        
x -= center_xoff
y -= center_yoff
        
if instance_exists(caller) {
    // make the enemy dialogue centered right-center
	if caller.object_index == o_ui_actordialogue {
        var __xoff = (caller.side == 1 ? -width : 0)
		x += __xoff
        center_xoff = __xoff
    }
	else if center_x {
        var __xoff = -width/2
		x += __xoff
        center_xoff = __xoff
    }
    
	if center_y {
		var __yoff = -height/2
		y += __yoff
        center_yoff = __yoff
    }
}

if caller.object_index == o_ui_actordialogue { // update enemy dialogue bubble size
    with caller {
        textx = other.x
        texty = other.y
        balloonwidth = other.width + 8
        balloonheight = other.height + 4
        inited = true
    }
}

if voice_replicate_start_bug
    __play_voice("a", true)