event_inherited()
var inst = enemy_struct.actor_id

if pattern == 0 { // explosions
    if timer > 0 {
        if timer % 60 == 0 {
            current_cutscene = cutscene_create()
            cutscene_set_variable(inst, "image_speed", 0)
            cutscene_set_variable(inst, "image_index", 3)
            
            cutscene_animate(0, 3, 10, "linear", inst, "shake")
            cutscene_sleep(15)
            
            cutscene_set_variable(inst, "image_index", 0)
            cutscene_animate(3, 0, 20, "linear", inst, "shake")
            
            cutscene_func(function(actor_inst) {
                var __eye = instance_create(o_ex_bullet_dentos_eye, actor_inst.x, actor_inst.y - 20, DEPTH_ENCOUNTER.BULLETS_OUTSIDE)
                var targetx = o_enc_box.x + random_range(-80, 50)
                var targety = o_enc_box.y + random_range(50, 70) * choose(-1, 1)
                
                if targetx < o_enc_box.x - o_enc_box.width/2 - 10 {
                    targety = o_enc_box.y + random_range(-70, 70)
                }
                
                do_animate(__eye.x, targetx, 20, "cubic_out", __eye, "x")
                do_animate(__eye.y, targety, 20, "cubic_out", __eye, "y")
            }, [inst])
            cutscene_set_variable(inst, "image_speed", 1)
            
            cutscene_play()
        }
    }
}