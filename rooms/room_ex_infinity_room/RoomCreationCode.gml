global.__transpose_player = function(dx, dy) {
    o_camera.x += dx;
    o_camera.y += dy;
    
    for (var i = 0; i < party_length(true); i ++) {
        var inst = party_get_inst(global.party_names[i]);
        inst.x += dx;
        inst.y += dy;
        party_member_interpolate(global.party_names[i]);
    }
}