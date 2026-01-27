var __audio = music_getplaying_id(target_slot)
timer ++

audio_sound_pitch(__audio, lerp(start_pitch, target_pitch, timer/target_time))
if timer >= target_time
    instance_destroy()