soul_vx = lerp(soul_vx, soul_x, .2)
soul_vy = lerp(soul_vy, soul_y, .2)

if view == 0 {
    soul_x = 50
    soul_y = 98
}
else if view == 1 {
    soul_x = 50
    soul_y = 408
}

timer ++