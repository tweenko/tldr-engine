/// @description start up
incomplete_ch = global.chapter

// prepare the shadowcrystals and completion for display
for (var i = 0; i < array_length(global.registered_chapters); ++i) {
	if is_struct(global.registered_chapters[i]) {
		var arr = []
		for (var j = 0; j < SAVE_SLOTS; ++j) {
			var v = save_read(j, i+1)
			if is_struct(v) {
				v = [v.CRYSTAL, v.COMPLETED]
                if v[0]
                    acquired_crystal = true
			}
			array_push(arr, v)
		}
		array_push(save_chs, arr)
	}
	else array_push(save_chs, -1)
}

var comp = false;
for (var j = 0; j < SAVE_SLOTS; ++j) {
	var v = save_chs[incomplete_ch-1]
	if is_array(v) && is_array(v[j])
	{
		if v[j][1]
            comp = true;
	}
}
if comp
	complete_ch = global.chapter
else
{
	incomplete_ch = global.chapter
	complete_ch = 0
}

txt = loc_string("chapter_select_start_1", incomplete_ch)
tselec = incomplete_ch

var startch = 0
for (var i = 0; i < array_length(global.registered_chapters); ++i) {
	if is_struct(global.registered_chapters[i]) {
		startch = i
		break
	}
}

if complete_ch == 0 && incomplete_ch == 0 {
	txt = loc_string("chapter_select_start_0", startch + 1)
	tselec = startch + q
}
if complete_ch == incomplete_ch && is_struct(global.registered_chapters[complete_ch] /*not complete_ch + 1 because array starts from 0 im so sorry*/) {
	txt = loc_string("chapter_select_start_2", complete_ch)
	yes = loc_string("chapter_select_start_2_yes", complete_ch+1)
	no = loc("chapter_select_start_2_no")
	tselec = complete_ch + 1
}

selection = startch + 1