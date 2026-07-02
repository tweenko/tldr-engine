event_inherited()
tile_width = 20
tile_height = 20

depth += wall_distance

inst_lining = instance_create(obj_plat_groundlining)
inst_lining.maker = self
if sprite_exists(lining_sprite) {inst_lining.sprite_index = lining_sprite}

collide_init = collide

plathidden = 1
floorbackclamping = floor_tilesback_amount