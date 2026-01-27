path = path_add()

xx = 200 // soul x
yy = 155 // soul y
shadx = 250
shady = 100
ency = 0

w = 320
q = 4

prog = 0
red = 0
timer = 0
buffer = 0
count = 0

path_set_closed(path, false)
path_set_kind(path, 1)

animate(0, 1, 15, "linear", id, "prog")
animate(0, 2, 30, "linear", id, "red")

alarm[0] = 35