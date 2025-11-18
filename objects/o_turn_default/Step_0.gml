event_inherited()

if timer == 1 {
    //var inst = instance_create(o_enc_box_solid, 180, o_enc_box.y, DEPTH_ENCOUNTER.BOX-1000)
    //inst.visible = true
    //inst.sprite_index = Sprite498
    //
    //do_animate(0, 720, 120, "linear", inst, "image_angle")
}
if timer > 0 {
    o_enc_box.image_angle ++
    o_enc_box.x = 160 + sine(20, 10)
    o_enc_box.width = 80 + sine(10, 10)
    //o_enc_box.height = 30 + cosine(10, 10)
}