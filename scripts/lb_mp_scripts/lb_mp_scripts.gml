// this is a default library for tldr engine

/// @desc pitches music during a cutscene
/// @arg {real} music_slot the music slot of the music you want to pitch
/// @arg {real} start_pitch the initial pitch
/// @arg {real} target_pitch the target pitch
/// @arg {real} target_time the time you want to change the pitch by
function lb_music_pitch(music_slot, start_pitch, target_pitch, target_time) {
	instance_create(o_lb_music_pitcher,,,, { 
        start_pitch,
        target_pitch,
        target_slot: music_slot, // your slot
        target_time, // the time you want to change the pitch by
    })
}

/// @desc pitches music during a cutscene
/// @arg {real} music_slot the music slot of the music you want to pitch
/// @arg {real} start_pitch the initial pitch
/// @arg {real} target_pitch the target pitch
/// @arg {real} target_time the time you want to change the pitch by
function cutscene_lb_music_pitch(music_slot, start_pitch, target_pitch, target_time) {
	cutscene_custom({
		music_slot, start_pitch, target_pitch, target_time,
		action: [lb_music_pitch, music_slot, start_pitch, target_pitch, target_time],
	})
}