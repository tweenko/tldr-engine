event_inherited()

open_override = undefined   // this will be called instead of normal opening if it's callable
                            // for custom open overrides, you must set the index, play the sound and set the state manually
empty_callback = function() {
    dialogue_start(loc("item_chest_empty"))
}

state_group = "chests_open"