global.player_spritelists[0]=[]
var i=0;
repeat (1000) {
	global.channelid[i]=0
	i++;
}
PlayerColl=new Collage("Players", 4096, 4096, false, 1, true)
CustomColl=new Collage("Custom", 4096, 4096, false, 1, true)
import_sheets();
enable_app_surf_redraw = false
if room==rGame {
	instance_create_depth(0,0,0,oBackgroundManager);
	instance_create_depth(0,0,0,oNodeManager);
	instance_create_depth(0,0,0,oDrawingManager);

	global.warptimer=0;
	global.yellow_switch=0;
	global.cyan_switch=0;
	global.magenta_switch=0;
	enable_app_surf_redraw = true
	instance_create_depth(0,0,depth -1,oTitlecard);
} 

parse_level(global.nextlevel)


alarm[0]=1;