if state_get("cutscene_seen") {
    instance_destroy()
    exit
}

global.party_names = ["kris", "susie", "ralsei"]

trigger_code = function() {

  

    cutscene_create()
    cutscene_player_canmove(false)
    cutscene_party_follow(false)
    cutscene_set_variable(o_camera, "target", noone)

    cutscene_func(music_fade, [0, 0])

   
    cutscene_dialogue([
        "{char(susie, 4)}* I think...",
        "{char(susie, 4)}* I think we lost it."
    ],,, false)

    cutscene_sleep(10)

    cutscene_dialogue([
        "{char(susie, 6)}* You THINK??",
        "{char(susie, 11)}* That thing was right on top of us!"
    ],,, false)

    cutscene_sleep(10)

    cutscene_dialogue([
        "{char(ralsei, 2)}* I don't hear it anymore...",
        "{char(ralsei, 3)}* But it's so dark down here..."
    ],,, false)

    cutscene_wait_dialogue_finish()

    // Subtle camera pan forward
    cutscene_camera_pan(undefined, 220, 40)

    cutscene_sleep(20)

    cutscene_dialogue([
        "{char(kris, 1)}* Yeah...",
        "{char(kris, 1)}* I can barely see anything."
    ],,, false)

    cutscene_sleep(20)

    cutscene_dialogue([
        "{char(kris, 5)}* Wait.",
        "{char(kris, 5)}* Do you guys see that?"
    ],,, false)

    cutscene_sleep(10)

    cutscene_dialogue([
        "{char(susie, 7)}* See what?",
        "{char(kris, 6)}* In the distance.",
        "{char(kris, 6)}* There's something glowing."
    ],,, false)

    cutscene_wait_dialogue_finish()

    cutscene_sleep(20)

    cutscene_dialogue([
        "{char(ralsei, 4)}* You're right...",
        "{char(ralsei, 4)}* It's faint, but it's there."
    ],,, false)

    cutscene_sleep(10)

    cutscene_dialogue([
        "{char(susie, 12)}* Great.",
        "{char(susie, 12)}* We just ran from a nightmare and now we're walking toward a glow in the dark."
    ],,, false)

    cutscene_sleep(10)

    cutscene_dialogue([
        "{char(kris, 2)}* It's better than standing here.",
        "{char(kris, 2)}* If it was that thing, we'd know."
    ],,, false)

    cutscene_sleep(15)

    cutscene_dialogue([
        "{char(ralsei, 1)}* Then... let's move before it finds us again."
    ],,, false)

    cutscene_wait_dialogue_finish()
    cutscene_sleep(20)

    cutscene_func(function(inst) {
        state_add("cutscene_seen", inst)
    }, [id])

    cutscene_party_follow(true)
    cutscene_party_interpolate()
    cutscene_player_canmove(true)

    cutscene_play()
}