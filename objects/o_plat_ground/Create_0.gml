event_inherited()
tile_width = 20
tile_height = 20

depth += wall_distance

inst_lining = instance_create(o_plat_groundlining)
inst_lining.maker = self
inst_lining.depth_start = (overlay_lining ? DEPTH_PLATFORMER.LINING + wall_distance : depth - 10);

if sprite_exists(lining_sprite) or is_callable(lining_drawer) {
    inst_lining.sprite_index = lining_sprite;
    inst_lining.drawer = lining_drawer;
}

plathidden = 1
floorbackclamping = floor_tilesback_amount