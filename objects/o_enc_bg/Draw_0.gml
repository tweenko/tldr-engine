x = guipos_x();
y = guipos_y();

if is_struct(background)
    background.bg_draw(image_alpha);

if is_struct(bulletdark)
    bulletdark.bulletdark_draw(fade);