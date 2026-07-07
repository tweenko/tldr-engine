trigger_code = function() {
    triggered = false;
    if !(get_leader().x - get_leader().xprevious < 0)
        exit;
        
    var dx = inst_edge_right.bbox_left - bbox_right;
    global.__transpose_player(dx, 0);
    
    triggered = false;
}