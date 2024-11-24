global.player_spritelists[0]=[]
PlayerColl=new Collage("Players", 4096, 4096, false, 1, true)
import_sheets();

parse_level(global.nextlevel)

instance_create(0,0,oBackgroundManager);

global.warptimer=0;
global.yellow_switch=0;
global.cyan_switch=0;
global.magenta_switch=0;