if keyboard_check(vk_escape) {
    if image_index >= 5 {
        game_end()
        exit
    }
    
    image_alpha += .05
    image_index += .1
}
else {
    if image_alpha > 0 {
        if state_prev {
            image_index = image_index % image_number
            image_alpha = clamp(image_alpha, 0, 1)
        }
        image_index -= .5
        image_index = max(0, image_index)
        
        image_alpha -= .1
    }
    else
    	image_index = 0
}

state_prev = keyboard_check(vk_escape)