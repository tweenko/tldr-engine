// parse tile data and convert tiles into climb tile objects

var __layers = layer_get_all();
for (var i = 0; i < array_length(__layers); i ++) {
    var __layer_id = __layers[i];
    if string_starts_with(layer_get_name(__layer_id), "climb") && layer_tilemap_exists(__layer_id, layer_tilemap_get_id(__layer_id)) {
        var map_id = layer_tilemap_get_id(__layer_id);
        if map_id == -1 // abort in case something goes wrong
            continue;
        
        var w = tilemap_get_width(map_id);
        var h = tilemap_get_height(map_id);
        var tile_origin_x = tilemap_get_x(map_id);
        var tile_origin_y = tilemap_get_y(map_id);
        var tile_w = tilemap_get_tile_width(map_id);
        var tile_h = tilemap_get_tile_height(map_id);
        
        for (var cx = 0; cx < w; cx ++) {
            for (var cy = 0; cy < h; cy ++) {
                var tile = tilemap_get(map_id, cx, cy);
                var xx = tile_origin_x + tile_w * cx;
                var yy = tile_origin_y + tile_h * cy;
                
                if tile == 2 // single block
                    instance_create(o_dev_climb_tile, xx + tile_w/2, yy + tile_h/2);
                if tile == 3 // double vertical block
                    instance_create(o_dev_climb_tile, xx + tile_w/2, yy + tile_h);
                if tile == 5 // double horizontal block
                    instance_create(o_dev_climb_tile, xx + tile_w, yy + tile_h/2);
            };
        };
        
        layer_set_visible(__layer_id, false);
    };
};