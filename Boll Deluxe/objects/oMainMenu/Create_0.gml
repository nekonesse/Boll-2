option=0;
optMAX=3;
crMenu="mainmenu";
subopt=0;
suboptMAX=3;
optionLock=0;
startLock = 10;

// General
OptionMover = function () {
	option	=wrap_val(option,0,optMAX);
	if (up)
	option-=1
	else if (down)
	option+=1
}
subOptMover = function () {
	subopt	=wrap_val(subopt,0,suboptMAX);
	if (up)
	subopt-=1
	else if (down)
	subopt+=1
}
backAmenu = function (_goback) {
	crMenu=_goback
	option=0
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
if (global.touchscreen) {instance_create(x,y,oTouchControl)}