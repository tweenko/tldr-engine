if !is_follower 
	init = true
if is_enemy 
	if autoheight 
		myheight = sprite_get_height(sprite_index)

if is_player || is_follower {
	s_hurt = party_getdata(name, "battle_sprites").hurt
	if autoheight 
		myheight = party_getbattleheight(name)
}