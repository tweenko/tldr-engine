/// @description initialize
if !is_undefined(shop_data.shopkeeper)
    inst_shopkeeper = instance_create(shop_data.shopkeeper, shop_data.shopkeeper_x, shop_data.shopkeeper_y, 0)

if audio_exists(shop_data.bgm)
    music_play(shop_data.bgm, 0, true, shop_data.bgm_gain, shop_data.bgm_pitch)