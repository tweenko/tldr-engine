if instance_exists(caller) {
    tp_visual = lerp(tp_visual, caller.tp, .3)
    tp_visual_fast = lerp(tp_visual_fast, caller.tp, .8)
}

if tp_glow_alpha > 0
    tp_glow_alpha -= .1