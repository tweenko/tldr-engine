event_inherited();
active = false;

/// @ignore
__spawn_text = function(idx, tx, ty, duration=undefined) {
	var typer = text_typer_create(loc("legend_lb")[idx], tx, ty,DEPTH_UI.DIALOGUE_UI, "{can_skip(false)}{shadow(false)}{speed(2)}{voice(nil)}{auto_breaks(false)}", "{stop}", {
			gui: true,
			caller: o_intro_legend,
			destroy_caller: false
		}
	)
		
	if !is_undefined(duration) {
		var ts = time_source_create(o_intro_legend.tsParent, duration, time_source_units_frames, instance_destroy, [typer]);
		time_source_start(ts);
	}
}