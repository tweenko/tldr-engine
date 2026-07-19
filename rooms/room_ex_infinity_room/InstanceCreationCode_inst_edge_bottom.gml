trigger_code = function() {
    triggered = false;
    if !(get_leader().y - get_leader().yprevious > 0)
        exit;
        
    var dy = inst_edge_top.bbox_bottom - bbox_top;
    global.__transpose_player(0, dy);
    
    triggered = false;
}