global.yellow_switch=0;
global.cyan_switch=0;
global.magenta_switch=0;
global.coins_collected=0;
global.paused=0;
global.conductive_array=[oAmp]

piping_object_depth = 0;

HUDsurface=surface_create(camera_get_view_width(view_camera[0]),camera_get_view_height(view_camera[0]))
bgMusic=undefined;
fgMusic=undefined;
bluefadeprog = shader_get_uniform(shd_bluefade, "staged_offset");
bluefadeinflag = shader_get_uniform(shd_bluefade, "fadein");

fadeprog = 0.0
fadein = false

enable_app_surf_redraw = false

hidden_tile_layers = [];

all_layers = [];