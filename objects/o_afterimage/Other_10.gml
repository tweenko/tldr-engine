if white == true
	gpu_set_fog(true,c_white,0,0)
if addblend
	gpu_set_blendmode(bm_add)

draw_self()

if addblend
	gpu_set_blendmode(bm_normal)
if white == true
	gpu_set_fog(false,c_white,0,0)