/// @desc plays music using music control
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
function music_isplaying(slot){
	if instance_exists(o_dev_musiccontrol){
		return o_dev_musiccontrol.playing_id[slot] != -1 
            && audio_is_playing(o_dev_musiccontrol.playing_id[slot])
	}
}

/// @desc check what music is playing
function music_getplaying(slot){
	if instance_exists(o_dev_musiccontrol){
		return o_dev_musiccontrol.playing[slot]
	}
}

/// @desc get the id of the music that's playing right now
function music_getplaying_id(slot){
	if instance_exists(o_dev_musiccontrol){
		return o_dev_musiccontrol.playing_id[slot]
	}
}

/// @desc stops the currently playing music in this certain slot
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
function music_pause(slot){
	if instance_exists(o_dev_musiccontrol){
		audio_pause_sound(o_dev_musiccontrol.curplaying_id[slot])
	}
}

/// @desc resumes a song in a certain slot.
function music_resume(slot){
	if instance_exists(o_dev_musiccontrol){
		audio_resume_sound(o_dev_musiccontrol.curplaying_id[slot])
	}
}

/// @desc fade a song in a certain slot
function music_fade(slot, time = 30){
	if instance_exists(o_dev_musiccontrol){
		audio_sound_gain(o_dev_musiccontrol.curplaying_id[slot], 0, 1000 * time/30)
	}
}