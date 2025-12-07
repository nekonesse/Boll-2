egg = "0"

window_set_cursor(cr_none)

#macro RESOLUTION_X 432
#macro RESOLUTION_Y 248

ysc = 0
xsc = 0
hsp = 10
frame = 0
boll = -1
bollStruct = {xsc : 1, ysc : 1, x : 0, y : 0, z : 0, xsp : 0, ysp : 0, zsp : 0}
stretch = 8
flash = 0
bolldive = 0
bounce = 0

//mode 7 init stuff
pos = shader_get_uniform(shd_mode7Ceiling, "position");
offset = shader_get_uniform(shd_mode7Ceiling, "offset");
angle = shader_get_uniform(shd_mode7Ceiling, "angle");
height = shader_get_uniform(shd_mode7Ceiling, "height");
mapSize = shader_get_uniform(shd_mode7Ceiling, "mapSize");
horizon = shader_get_uniform(shd_mode7Ceiling, "horizon");
shaderUV = shader_get_uniform(shd_mode7Ceiling, "spriteUV");
//GLSL is such a bitch i couldnt get the ceiling variable to work

spriteUV = sprite_get_uvs(spr_titleclouds,0);
spriteUV[2] = spriteUV[2] - spriteUV[0];
spriteUV[3] = spriteUV[3] - spriteUV[1];