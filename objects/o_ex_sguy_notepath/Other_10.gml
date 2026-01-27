path_clear_points(path)

ency = 120

path_add_point(path, shadx, shady, 100)
path_add_point(path, shadx - 50, shady - (yy-ency) / 4, 100)
path_add_point(path, xx, yy, 100)
path_add_point(path, xx - 70,yy + (yy-ency)/2, 100)
path_add_point(path, guipos_x()-40, shady + (yy-ency)/4, 100)