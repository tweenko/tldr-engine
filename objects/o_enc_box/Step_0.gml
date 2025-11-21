if is_transitioning {
    var inst = afterimage(.04, self, false, drawer)
    
    inst.sprite_index = trans_sprite
    inst.image_alpha = lerp(.7, .2, trans_lerp)
    inst.image_xscale = sprite_w * temp_scale
    inst.image_yscale = sprite_h * temp_scale
    inst.image_angle = temp_angle
    inst.depth -= 10
    inst.blend = bm_zero
    
    image_alpha = lerp(.5, 1, trans_lerp)
}

if timer == 15
    is_transitioning = false

image_xscale = width/sprite_w
image_yscale = height/sprite_h

timer ++