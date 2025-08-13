if (timer >= 9 && timer <= 30) {
    draw_set_alpha(2.2 - (timer / 10))
    draw_set_color(c_white)
    draw_circle(x, y, (timer/3 - 3) * 10, true)
    draw_circle(x, y, (timer/3 - 3) * 11, true)
    draw_set_alpha(1)
}