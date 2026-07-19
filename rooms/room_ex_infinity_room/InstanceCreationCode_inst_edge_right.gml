trigger_code = function() {
    triggered = false;
    if !(get_leader().x - get_leader().xprevious > 0)
        exit;
        
    var dx = inst_edge_left.bbox_right - bbox_left;
    global.__transpose_player(dx, 0);
}