if sprite_index != prev_sprite {
    sprite_w = sprite_get_width(sprite_index)
    sprite_h = sprite_get_height(sprite_index)
    
    prev_sprite = sprite_index
}

event_inherited()