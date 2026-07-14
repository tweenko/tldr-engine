if instance_exists(caller) {
    var target_tp = clamp(caller.tp, 0, 100);
    
    tp_visual = clamp(lerp(tp_visual, target_tp, .3), 0, 100);
    tp_visual_fast = clamp(lerp(tp_visual_fast, target_tp, .8), 0, 100);
    
    if abs(tp_visual - target_tp) < .4 
        tp_visual = target_tp;
    if abs(tp_visual_fast - target_tp) < .4 
        tp_visual_fast = target_tp;
}

if tp_glow_alpha > 0
    tp_glow_alpha -= .1