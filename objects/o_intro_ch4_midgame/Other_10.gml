x = 160;
y = 120;

surf = -1;
active = false;

drawSurface = true;

depthOff = 0;
depthOffSpd = -0.6;

spr = spr_dw_church_prophecy_final_icon_w;
sprW = sprite_get_width(spr);
sprH = sprite_get_height(spr);

afterimageOffset = 0;

cutscene_create();
	cutscene_sleep(1);
	cutscene_set_variable(id, "active", true);
cutscene_play();