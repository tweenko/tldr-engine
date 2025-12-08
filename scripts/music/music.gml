function music_update() {
    with o_dev_musiccontrol
        event_user(0)
}
function music_slot_reset(_slot) {
    with o_dev_musiccontrol {
        music_target[_slot] = -1
        music_actual[_slot] = -1
        
        loop[_slot] = false
        gain[_slot] = 1
        pitch[_slot] = 1
    }
}

/// @desc plays music using music control
/// @arg {Asset.GMSound} _sound the sound to use as the music
/// @arg {real} _slot the channel you'll be playing the music at
function music_play(_sound, _slot, _loop = true, _gain = 1, _pitch = 1) {
	if !instance_exists(o_dev_musiccontrol)
        return false
    
    with o_dev_musiccontrol {
        music_target[_slot] = _sound
        loop[_slot] = _loop
        gain[_slot] = _gain
        pitch[_slot] = _pitch
        slot = _slot
    }
    
    music_update()
}

/// @desc checks whether any music is playing in a certain slot
/// @arg {real} slot the channel you want to check for any music playing
function music_isplaying(slot){
	if !instance_exists(o_dev_musiccontrol)
        return false
        
    return o_dev_musiccontrol.music_actual[slot] != -1 
        && audio_is_playing(o_dev_musiccontrol.music_target[slot])
}

/// @desc check what music is playing
/// @arg {real} slot the channel you want to get the sound playing from
function music_getplaying(slot){
    if !instance_exists(o_dev_musiccontrol)
        return false
	return o_dev_musiccontrol.__get_actual_music_asset(slot)
}
/// @desc get the id of the music that's playing right now
/// @arg {real} slot the channel you want to get the sound id of
function music_getplaying_id(slot){
	if !instance_exists(o_dev_musiccontrol)
        return false
    return o_dev_musiccontrol.music_actual[slot]
}

/// @desc stops the currently playing music in this certain slot
/// @arg {real} slot the channel you want to stop the song of
function music_stop(slot){
	if !instance_exists(o_dev_musiccontrol)
        return false
    
    audio_stop_sound(o_dev_musiccontrol.music_actual[slot])
    music_slot_reset(slot)
}
/// @desc stops music in all the slots
function music_stop_all(){
    if !instance_exists(o_dev_musiccontrol)
        return false
    
    for (var i = 0; i < o_dev_musiccontrol.channels; ++i) {
        audio_stop_sound(o_dev_musiccontrol.music_actual[i])
        music_slot_reset(i)
    }
}

/// @desc pauses the song in a certain slot. resume with music_resume
/// @arg {real} slot the channel you want to pause the song of
function music_pause(slot){
    if !instance_exists(o_dev_musiccontrol)
        return false
	audio_pause_sound(o_dev_musiccontrol.music_actual[slot])
}
/// @desc resumes a song in a certain slot
/// @arg {real} slot the channel you want to resume the song of
function music_resume(slot){
    if !instance_exists(o_dev_musiccontrol)
        return false
    audio_resume_sound(o_dev_musiccontrol.music_actual[slot])
}

/// @desc fade a song in a certain slot
/// @arg {real} slot the channel you want to get fade out
/// @arg {real} target_gain the gain you'd like to reach
/// @arg {real} time the time in frames you want to fade out the music
function music_fade(slot, target_gain, time = 30){
	if !instance_exists(o_dev_musiccontrol)
        return false
    
    audio_sound_gain(o_dev_musiccontrol.music_actual[slot], target_gain * volume_get(AUDIO.MUSIC), 1000 * time/30)
}