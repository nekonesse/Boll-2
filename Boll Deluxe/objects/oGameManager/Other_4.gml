global.player_spritelists[0]=[]
pal_swap_init_system(shd_pal_swapper);
PlayerColl=new Collage("Players", 4096, 4096, false, 1, true)
import_sheets();

instance_create_depth(0,0,0,oBackgroundManager);
instance_create_depth(0,0,0,oNodeManager);
instance_create_depth(0,0,0,oDrawingManager);

parse_level(global.nextlevel)

global.warptimer=0;
global.yellow_switch=0;
global.cyan_switch=0;
global.magenta_switch=0;

alarm[0]=1;