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

with(oCamera) {
	xwidth = camera_get_view_width(view_camera[0]);
	ywidth = camera_get_view_height(view_camera[0]);

	xx = median(0, xmax, target.x + (x - xprevious) - (xwidth/2));
	yy = median(0, ymax, target.y + (y - yprevious) - (ywidth/2));
	
	camera_set_view_pos(view_camera[0],xx,yy);
}


alarm[0]=1;