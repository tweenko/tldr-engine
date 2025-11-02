channels = 4

music_target = array_create(channels, -1)
music_actual = array_create(channels, -1)

gain = array_create(channels, 1)
pitch = array_create(channels, 1)
loop = array_create(channels, 1)

slot = 0

__get_actual_music_asset = function(slot) {
    return audio_sound_get_asset(music_actual[slot])
}