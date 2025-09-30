/// @description start up
incomplete_ch=global.chapter
if save_get("completed"){
	complete_ch=global.chapter
}
else{
	incomplete_ch=global.chapter
	complete_ch=0
}

txt=string(loc("chapter_select_start_1"), incomplete_ch)
tselec=incomplete_ch

var startch=0
for (var i = 0; i < array_length(chapters); ++i) {
	if is_struct(chapters[i]){
		startch=i
		break
	}
}

if complete_ch==0&&incomplete_ch==0{
	txt = string(loc("chapter_select_start_0"), startch+1)
	tselec=startch+q
}
if complete_ch==incomplete_ch{
	txt = string(loc("chapter_select_start_2"), complete_ch)
	yes = string(loc("chapter_select_start_2_yes"), complete_ch+1)
	no = loc("chapter_select_start_2_no")
	tselec=complete_ch+1
}

selection=startch+1

//prepare the shadowcrystals and completion for display
for (var i = 0; i < array_length(chapters); ++i) {
	if is_struct(chapters[i]){
		var arr=[]
		for (var j = 0; j < SAVE_SLOTS; ++j) {
			var v=save_read(j,i+1)
			if is_struct(v){
				v=[v.CRYSTAL, v.COMPLETED]
			}
			array_push(arr, v)
		}
		array_push(save_chs, arr)
	}
	else array_push(save_chs, -1)
}