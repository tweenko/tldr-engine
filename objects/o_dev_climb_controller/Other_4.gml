// parse tile data and convert tiles into climb tile objects

var __layers = layer_get_all();
for (var i = 0; i < array_length(__layers); i ++) {
    var __layer_id = __layers[i];
    if string_starts_with(layer_get_name(__layer_id), "climb") {
        var map_id = layer_tilemap_get_id(__layer_id);
        if map_id == -1 // abort in case something goes wrong
            continue;
        
        var w = tilemap_get_width(map_id);
        var h = tilemap_get_height(map_id);
        
        for (var cx = 0; cx < w; cx ++) {
            for (var cy = 0; cy < h; cy ++) {
                var tile = tilemap_get(map_id, cx, cy);
                
                if tile == 2 // single block
                    instance_create(o_dev_climb_tile, tilemap_get_x(tile), tilemap_get_y(tile));
                if tile == 4 // double vertical block
                    instance_create(o_dev_climb_tile, tilemap_get_x(tile) + tilemap_get_tile_width(tile)/2, tilemap_get_y(tile));
                if tile == 6 // double horizontal block
                    instance_create(o_dev_climb_tile, tilemap_get_x(tile), tilemap_get_y(tile) + tilemap_get_tile_height(tile)/2);
            };
        };
    };
};