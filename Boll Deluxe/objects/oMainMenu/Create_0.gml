option=0;
optMAX=3;
crMenu="mainmenu";
subopt=0;
suboptMAX=3;
optionLock=0;
startLock = 10;

menusurface=surface_create(camera_get_view_width(view_camera[0]),camera_get_view_height(view_camera[0]))

selectArrowYtrans = room_height/2;
selectArrowY = room_height/2;
selectArrowWidth = 0;
selectArrowWidthtrans = 0;

// General
OptionMover = function () {
	if (up)
	option-=1
	else if (down)
	option+=1
	
	option	=wrap_val(option,0,optMAX);
}
subOptMover = function () {
	if (up)
	subopt-=1
	else if (down)
	subopt+=1
	
	subopt	=wrap_val(subopt,0,suboptMAX);
}
backAmenu = function (_goback) {
	crMenu=_goback
	option=0
	
	selectArrowYtrans = room_height/2;
	selectArrowY = room_height/2;
}

//Rebind Menu
rebindKey = function(_giveBind) {
	lemmebind = _giveBind;
	input_binding_scan_abort();
	input_binding_scan_start(function(_binding)
	{
		input_binding_set_safe(lemmebind, _binding);
	});
}

//Touch Control
if (global.touchscreen=1) {instance_create(x,y,oTouchControl)}