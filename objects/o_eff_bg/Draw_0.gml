var xx = guipos_x()
var yy = guipos_y()

siner += 0.25
siner2 += .5

draw_set_alpha(image_alpha)
draw_set_color(c_black)
draw_rectangle(-10, -10, (guipos_x()+320 + 10), (guipos_y()+240 + 10), false)
draw_set_alpha(1)
if ((destroy == 0))
{
    if ((image_alpha <= 1))
        image_alpha += 0.1
}
if ((bgtype == 0))
{
    draw_sprite_tiled_ext(spr_enc_bg, 0, round_p((-50 + siner),.25), round_p((-50 + siner),.25), .5, .5, image_blend, (image_alpha / 2))
    draw_sprite_tiled_ext(spr_enc_bg, 0, round_p((-100 - siner2),.25), round_p((-105 - siner2),.25), .5, .5, image_blend, image_alpha)
}
if ((bgtype == 1))
    draw_sprite_ext(spr_enc_bg_dojo, 0, (xx + (160 / 2)), (yy + 170/2), (1 + (sin((siner / 2)) * 0.004)), (1 + (cos((siner / 2)) * 0.004)), 0, image_blend, image_alpha)
if ((siner >= 100))
    siner -= 100
if ((siner2 >= 100))
    siner2 -= 100

if ((destroy == 1))
{
    image_alpha -= 0.1
    if ((image_alpha <= 0))
        instance_destroy()
}
draw_set_alpha(fade)
draw_set_color(c_black)
draw_rectangle(-10, -10, (guipos_x()+320 + 10), (guipos_y()+240 + 10), false)
draw_set_alpha(1)
draw_set_color(c_white)