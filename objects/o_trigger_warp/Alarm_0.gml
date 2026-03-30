room_goto(target_room)
if audio_exists(exit_sound)
    audio_play(exit_sound)

call_later(2, time_source_units_frames, function() {
    party_leader_warp("land", target_marker, exit_direction ?? savedir)
    call_later(1, time_source_units_frames, function() {
        fader_fade(1, 0, 10)
    })
})