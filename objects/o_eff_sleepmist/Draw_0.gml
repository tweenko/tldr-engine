var amp = sine(9, 15, siner)

image_alpha = sine(9, 1, siner) - 0.3 + success * 0.3

draw_sprite_ext(sprite_index, image_index, x + sine(6, amp, siner), y + cosine(6, amp/2, siner),
    image_xscale, image_yscale,
    image_angle, image_blend, image_alpha * .8
)
draw_sprite_ext(sprite_index, image_index, x - sine(6, amp, siner), y - cosine(6, amp/2, siner),
    image_xscale, image_yscale,
    image_angle, image_blend, image_alpha * .8
)