(this is a default tldr engine library)
# *Dark Lighting v1.0.1*
you can view the original discord post [here](https://discord.com/channels/1396840809722282005/1452346960978776305)!

    
# setup (< v1.8.0)
*you do not need to do any of the steps below if your version of 
tlDR Engine is above or equal to v1.8.0!*
1. you should add the following code to `o_actor`'s Draw event:
```gml
if instance_exists(o_lb_dl_controller) {
    surface_set_target(o_lb_dl_controller.surf_light)
        gpu_set_fog(true, lb_dl_highlight_color, 0, 1)
        s_drawer(spr, image_index, 
            (xx - guipos_x())*2, (yy - guipos_y())*2, 
            image_xscale*2, image_yscale*2, 
            image_angle, c_white, 1
        )
        gpu_set_fog(false, 0, 0, 0)
        
        gpu_set_blendmode(bm_subtract)
        s_drawer(spr, image_index, 
            (xx - guipos_x())*2, (yy+1 - guipos_y())*2, 
            image_xscale*2, image_yscale*2, 
            image_angle, c_black, 1
        )
        gpu_set_blendmode(bm_normal)
    surface_reset_target()
}
```
2. add the following to `o_actor`'s Create Event:
```gml

lb_dl_highlight_color = c_white
```
3. and add this to `o_actor`'s User Event 2's end [like so](https://file.garden/ZvQQDBEp-g6A9T-J/tutorial%20for%20the%20dark%20lighting%20thing.png)
```gml
if is_follower || is_player
    lb_dl_highlight_color = merge_colour(party_getdata(name, "iconcolor"), c_white, .4)
```
4. enjoy!