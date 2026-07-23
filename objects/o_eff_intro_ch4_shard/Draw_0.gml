if sprite_exists(sprite_index) {
	draw_sprite(sprite_index, image_index, x-!spriteIsCentered*sprite_width/2, y-!spriteIsCentered*sprite_height/2);
}
else {
	draw_circle(x, y, 3, true);
}

if y >= yTarget {
	instance_destroy();
}
