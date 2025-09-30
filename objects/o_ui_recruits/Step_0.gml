var recruit_array = global.recruits
var __page = selection div page_max
var __page_max = min(array_length(recruit_array), page_max * __page + page_max)
var __total_pages = ceil(array_length(recruit_array) / page_max)

if view == 0 {
    if InputPressed(INPUT_VERB.LEFT) {
        selection -= page_max
        __page --
    }
    else if InputPressed(INPUT_VERB.RIGHT) {
        selection += page_max
        __page ++
    }
    
    __page = (__page + __total_pages) % __total_pages
    __page_max = min(array_length(recruit_array), page_max * __page + page_max)
    
    if InputPressed(INPUT_VERB.DOWN) {
        selection ++
    }
    else if InputPressed(INPUT_VERB.UP) {
        selection --
    }
    
    if selection > __page_max-1
        selection = __page * page_max
    if selection < __page * page_max
        selection = __page_max-1
    
    if InputPressed(INPUT_VERB.SELECT) {
        view = 1
    }
    if InputPressed(INPUT_VERB.CANCEL) {
        instance_destroy()
    }
    
    soul_x = 50
    soul_y = 98 + (selection - __page*page_max) * 35
}
else if view == 1 {
    soul_x = 50
    soul_y = 408
    
    if InputPressed(INPUT_VERB.LEFT) {
        selection -= 1
    }
    else if InputPressed(INPUT_VERB.RIGHT) {
        selection += 1
    }
    
    if selection > array_length(recruit_array)-1
        selection = 0
    if selection < 0
        selection = array_length(recruit_array)-1
    
    if InputPressed(INPUT_VERB.CANCEL) {
        view = 0
    }
}

soul_vx = lerp(soul_vx, soul_x, .5)
soul_vy = lerp(soul_vy, soul_y, .5)

timer ++