surface_free(surf)

var kris = get_leader()
var char_y = kris.y - (sprite_get_height(kris.sprite_index)/2);
instance_create(o_eff_soulappear, kris.x, char_y, depth-10)

if instance_exists(o_enc_soul_aura)
    instance_destroy(o_enc_soul_aura)