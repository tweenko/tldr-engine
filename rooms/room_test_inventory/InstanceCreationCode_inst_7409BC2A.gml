trigger_exit_code = function() {
    var __healed = false
    for (var i = 0; i < array_length(global.party_names); i ++) {
        if party_getdata(global.party_names[i], "hp") != party_getdata(global.party_names[i], "max_hp") {
            party_setdata(global.party_names[i], "hp", party_getdata(global.party_names[i], "max_hp"))
            __healed = true
        }
    }
    
    if __healed {
        cutscene_create()
        cutscene_dialogue("* (As you left the battlefield, you felt a bit better...)")
        cutscene_audio_play(snd_heal)
        cutscene_play()
    }
    
    triggered = false
}