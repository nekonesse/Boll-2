global.yellow_switch=0;
global.cyan_switch=0;
global.magenta_switch=0;
global.coins_collected=0;
global.paused=0;
global.conductive_array=[oAmp]

HUDsurface=surface_create(camera_get_view_width(view_camera[0]),camera_get_view_height(view_camera[0]))
bgMusic=-1;
fgMusic=-1;
bluefadeprog = shader_get_uniform(shd_bluefade, "staged_offset");
bluefadeinflag = shader_get_uniform(shd_bluefade, "fadein");

fadeprog = 0.0
fadein = false

enable_app_surf_redraw = false