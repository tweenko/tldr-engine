/// @description initialize
inst_shopkeeper = instance_create(shop_data.shopkeeper, 160, 120, 0)
if audio_exists(shop_data.bgm)
    music_play(shop_data.bgm, 0, true, shop_data.bgm_gain, shop_data.bgm_pitch)