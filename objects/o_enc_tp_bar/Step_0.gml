if instance_exists(caller) {
    tp_visual = clamp(lerp(tp_visual, caller.tp, .3), 0, 100)
    tp_visual_fast = clamp(lerp(tp_visual_fast, caller.tp, .8), 0, 100)
}

if tp_glow_alpha > 0
    tp_glow_alpha -= .1