/// @desc plays music using music control
/// @arg {Asset.GMSound} sound the sound to use as the music
/// @arg {real} slot the channel you'll be playing the music at
function music_play(sound, slot, loop = true, gain = 1, pitch = 1) {
	if instance_exists(o_dev_musiccontrol) {
		o_dev_musiccontrol.playing[slot] = sound
		o_dev_musiccontrol.loop[slot] = loop
		o_dev_musiccontrol.gain[slot] = gain
		o_dev_musiccontrol.pitch[slot] = pitch
		o_dev_musiccontrol.slot = slot
		
        with o_dev_musiccontrol
			event_user(0)
	}
}

/// @desc checks whether any music is playing in a certain slot
/// @arg {real} slot the channel you want to check for any music playing
function music_isplaying(slot){
	if instance_exists(o_dev_musiccontrol){
		return o_dev_musiccontrol.playing_id[slot] != -1 
            && audio_is_playing(o_dev_musiccontrol.playing_id[slot])
	}
}

/// @desc check what music is playing
/// @arg {real} slot the channel you want to get the sound playing from
function music_getplaying(slot){
	if instance_exists(o_dev_musiccontrol){
		return o_dev_musiccontrol.playing[slot]
	}
}

/// @desc get the id of the music that's playing right now
/// @arg {real} slot the channel you want to get the sound id of
function music_getplaying_id(slot){
	if instance_exists(o_dev_musiccontrol){
		return o_dev_musiccontrol.playing_id[slot]
	}
}

/// @desc stops the currently playing music in this certain slot
/// @arg {real} slot the channel you want to stop the song of
function music_stop(slot){
	if instance_exists(o_dev_musiccontrol){
		audio_stop_sound(o_dev_musiccontrol.curplaying_id[slot])
		o_dev_musiccontrol.curplaying[slot] = -1
		o_dev_musiccontrol.curplaying_id[slot] = -1
		o_dev_musiccontrol.playing_id[slot] = -1
		o_dev_musiccontrol.playing[slot] = -1
	}
}

/// @desc stops music in all the slots
function music_stop_all(){
	if instance_exists(o_dev_musiccontrol){
		for (var i = 0; i < o_dev_musiccontrol.channels; ++i) {
			audio_stop_sound(o_dev_musiccontrol.curplaying_id[i])
			o_dev_musiccontrol.curplaying[i] = -1
			o_dev_musiccontrol.curplaying_id[i] = -1
			o_dev_musiccontrol.playing_id[i] = -1
			o_dev_musiccontrol.playing[i] = -1
		}
	}
}

/// @desc pauses the song in a certain slot. resume with music_resume
/// @arg {real} slot the channel you want to pause the song of
function music_pause(slot){
	if instance_exists(o_dev_musiccontrol){
		audio_pause_sound(o_dev_musiccontrol.curplaying_id[slot])
	}
}

/// @desc resumes a song in a certain slot
/// @arg {real} slot the channel you want to resume the song of
function music_resume(slot){
	if instance_exists(o_dev_musiccontrol){
		audio_resume_sound(o_dev_musiccontrol.curplaying_id[slot])
	}
}

/// @desc fade a song in a certain slot
/// @arg {real} slot the channel you want to get fade out
/// @arg {real} target_gain the gain you'd like to reach
/// @arg {real} time the time in frames you want to fade out the music
function music_fade(slot, target_gain, time = 30){
	if instance_exists(o_dev_musiccontrol){
		audio_sound_gain(o_dev_musiccontrol.curplaying_id[slot], target_gain * volume_get(1), 1000 * time/30)
	}
}