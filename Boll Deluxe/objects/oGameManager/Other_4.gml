global.player_spritelists[0]=[]
var i=0;
repeat (1000) {
	global.channelid[i]=0
	i++;
}

PlayerColl=new Collage("Players", 4096, 4096, false, 1, true)
CustomColl=new Collage("Custom", 4096, 4096, false, 1, true)
import_sheets();
enable_app_surf_redraw = true
if room==rGame {
	instance_create_depth(0,0,0,oBackgroundManager);
	instance_create_depth(0,0,0,oNodeManager);
	instance_create_depth(0,0,0,oDrawingManager);

	global.warptimer=0;
	global.yellow_switch=0;
	global.cyan_switch=0;
	global.magenta_switch=0;
	//enable_app_surf_redraw = true
	//instance_create_depth(0,0,depth -1,oTitlecard);
} 

var w = RESOLUTION_X*global.settings[$ "resolution_scale"];
var h = RESOLUTION_Y*global.settings[$ "resolution_scale"];

if (global.settings[$ "fullscreen_type"]) {
	w = display_get_width();
	h = display_get_height();
}

var mode = STANNCAM_WINDOW_MODE.WINDOWED;

if (global.settings[$ "fullscreen_type"]==1) {
	mode = STANNCAM_WINDOW_MODE.BORDERLESS;
} else if (global.settings[$ "fullscreen_type"]==2) {
	mode = STANNCAM_WINDOW_MODE.FULLSCREEN;
}

parse_level(global.nextlevel)

/*stanncam_init(RESOLUTION_X, RESOLUTION_Y, w, h,RESOLUTION_X,RESOLUTION_Y,mode);
main_camera = new stanncam(oPlayer.x, oPlayer.y, RESOLUTION_X, RESOLUTION_Y);
main_camera.follow = oPlayer; // This will follow the player object*/

/*with(oCamera) {
	xwidth = camera_get_view_width(view_camera[0]);
	ywidth = camera_get_view_height(view_camera[0]);

	xx = median(0, xmax, target.x + (x - xprevious) - (xwidth/2));
	yy = median(0, ymax, target.y + (y - yprevious) - (ywidth/2));
	
	camera_set_view_pos(view_camera[0],xx,yy);
}*/


alarm[0]=1;