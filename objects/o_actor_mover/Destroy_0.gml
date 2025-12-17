array_set(global.charmove_insts, pos, undefined)
character.moveable_move = true
if override = false
{
    character.s_override = false
}
else {
	character.s_override = true
    character.image_index = 0
    character.image_speed = 0
}