if active {
	draw_sprite(sprite_index, image_index, x, y+logoYOff);
	
	if showChapter {
		draw_sprite(spr_intro_chapter_number, 2, x, y+chYOff);
	}
}