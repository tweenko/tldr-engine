event_inherited()
tile_width = 20
tile_height = 20

depth += wall_distance
depth_platforming = undefined;
depth_start = depth;

inst_lining = instance_create(o_ow_plat_groundlining);
inst_lining.maker = self;

if is_callable(lining_drawer)
    inst_lining.drawer = lining_drawer;
else if sprite_exists(lining_sprite) 
    inst_lining.sprite_index = lining_sprite;

plathidden = 1
floorbackclamping = floor_tilesback_amount

initial_y = y;