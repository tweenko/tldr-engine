// this is a default library for tldr engine
// Beat Pulser v1.0.1

/// @desc creates a beat pulser that emits signals. call the methods to receieve beats.
/// @arg {real} bgm_slot the slot of the backing audio
/// @arg {real} bpm the beats per minute of the song
/// @arg {real} time_sig_numerator time signature. the top number
/// @arg {real} time_sig_denominator time signature. the bottom number
/// @arg {real} audio_offset the offset of the audio (in ms)
function beat_pulser(_bgm_slot, _bpm = 140, _time_sig_numerator = 4, _time_sig_denominator = 4, _audio_offset = 0) constructor {
    bgm_slot = _bgm_slot
    bpm = _bpm 
    audio_offset = _audio_offset
    
    time_sig_numerator = _time_sig_numerator
    time_sig_denominator = _time_sig_denominator
    
    __time_sig_coeff = log2(time_sig_denominator) / 2
    __last_beat = undefined
    __last_beat_frame = 0
    __all_beats = array_create_ext(time_sig_numerator, function(index) {return index + 1})
    
    /// @desc will emit a signal every time the current beat reaches a beat number passed in the argument
    /// @arg {real|array<real>} beat_numbers the beat number(s) the function will return true to (starts from 1)
    beat = method(self, function(beat_numbers) {
        var audio = music_getplaying_id(bgm_slot)
        if !audio_exists(audio)
            return false
        
        var audio_pos = audio_sound_get_track_position(audio) + audio_offset
        var current_beat = floor(audio_pos * bpm/60 * __time_sig_coeff % time_sig_numerator) + 1
        
        if current_beat == __last_beat && __last_beat_frame != o_world.frames
            return false
        __last_beat = current_beat
        __last_beat_frame = o_world.frames
        
        if is_real(beat_numbers)
            return current_beat == beat_numbers
        else 
            return array_contains(beat_numbers, current_beat)
    })
    /// @desc will emit a signal every time the current beat changes. akin to calling `beat` for all beats.
    every = method(self, function() {
        return beat(__all_beats)
    })
}