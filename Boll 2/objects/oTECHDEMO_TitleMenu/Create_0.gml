option=0;
optMAX=3;
crMenu="mainmenu";
subopt=0;
suboptMAX=3;
optionLock=0;
startLock = 10;
lemmebind = -1;

on_title = 1;

title_offset = 0;

temp_settings = global.settings

menusurface=surface_create(camera_get_view_width(view_camera[0]),camera_get_view_height(view_camera[0]))

selectArrowYtrans = room_height/2;
selectArrowY = room_height/2;
selectArrowWidth = 0;
selectArrowWidthtrans = 0;

// General
OptionMover = function () {
	if (up) {
	   option-=1 VinylPlay(test_ui_highlight);
    }
	else if (down) {
	   option+=1 VinylPlay(test_ui_highlight);
    }
	
	option	=wrap_val(option,0,optMAX);
}
subOptMover = function () {
	if (up) {
	   subopt-=1 VinylPlay(test_ui_highlight);
    }
	else if (down) {
	   subopt+=1 VinylPlay(test_ui_highlight);
    }
	
	subopt	=wrap_val(subopt,0,suboptMAX);
}
backAmenu = function (_goback) {
    VinylPlay(test_ui_cancel);
	crMenu=_goback
	option=0
	
	selectArrowYtrans = room_height/2;
	selectArrowY = room_height/2;
}

//Rebind Menu
rebindKey = function(_giveBind) {
	lemmebind = _giveBind;
	var _device = InputPlayerGetDevice();
	//Begin rebinding for the device that the player is currently using
	var _ignoreArray = [
		vk_alt, vk_capslock, vk_printscreen,vk_escape,gp_start
	];
	InputDeviceSetRebinding(_device, true, _ignoreArray);
}

//Touch Control
if (global.touchscreen=1) {instance_create(x,y,oTouchControl)}