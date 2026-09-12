/// @description start up
incomplete_ch = global.chapter

for (var i = 0; i < array_length(global.registered_chapters); i ++) {
    var _chapter = global.registered_chapters[i];
    
    if !is_struct(_chapter)
        continue;
    
    var _target_ch = _chapter.target_chapter;
    chapter_parsed_data[i] = {
        any_completed: save_is_chapter_completed(_target_ch),
        completed_slots: array_create_ext(SAVE_SLOTS, method({chapter: _target_ch}, function(index) { return (save_is_slot_completed(index, chapter) 
            ? (save_exists(index, chapter) ? "completed" : "completed_before") 
            : "not_completed"
        ); })),
        crystal_slots: array_create_ext(SAVE_SLOTS, method({chapter: _target_ch}, 
            function(index) { 
                if !save_exists(index, chapter) 
                    return false;
                if save_read(index, chapter).CRYSTAL
                    return true;
                return false;
            })
        )
    }
}

if save_is_chapter_completed()
	complete_ch = global.chapter;
else {
	incomplete_ch = global.chapter;
	complete_ch = 0;
}

txt = loc_string("chapter_select_start_1", incomplete_ch)
tselec = incomplete_ch - 1

var startch = 0
for (var i = 0; i < array_length(global.registered_chapters); ++i) {
	if is_struct(global.registered_chapters[i]) {
		startch = i
		break
	}
}

if complete_ch == 0 && incomplete_ch == 0 {
	txt = loc_string("chapter_select_start_0", startch + 1)
	tselec = startch
}
if complete_ch == incomplete_ch && is_struct(global.registered_chapters[complete_ch + 1]) {
	txt = loc_string("chapter_select_start_2", complete_ch)
	yes = loc_string("chapter_select_start_2_yes", complete_ch+1)
	no = loc("chapter_select_start_2_no")
	tselec = complete_ch
}

selection = startch + 1