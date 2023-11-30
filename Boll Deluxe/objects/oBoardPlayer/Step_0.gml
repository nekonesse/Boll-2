right=input_check("right");
left=input_check("left");
up=input_check("up");
down=input_check("down");
akey=input_check("jump");
apress=input_check_pressed("jump");
bkey=input_check("action");
bpress=input_check_pressed("action");
ckey=input_check("special");
cpress=input_check_pressed("special");

if !instance_exists(mydice) {
	mydice=undefined;
}

if state=="idle" && (akey) {
	alarm[0]=10
}

if state=="rolling" {
	if !(jumped) && (akey) && instance_exists(mydice) && (mydice.rolling) {
		curr_y=y;
		vsp=-5;
		jumped=1;
	}

	if (jumped) vsp=min(4,vsp+grav)

	if y>curr_y {
		vsp=0
		y=curr_y;
		jumped=0
	}

	y+=vsp;
	y=round(y)
}

if state=="moving" {
	if path_index = -1 {
		path_start(Path1,path_speed,path_action_stop,true);
	}
	space=instance_place(x,y,oSpacePar)
	if (space) && collision_rectangle(floor(x)-1,floor(y)-1,floor(x)+1,floor(y)+1,space,false,true) {
		if (space!=spaceid) && (oBoardController.finalvalue[0] != 0) {
			oBoardController.finalvalue[0]-=1
			spaceid=space
		}
		
		if (oBoardController.finalvalue[0] == 0)
		{
			path_speed=0;
			
			oBoardController.popup_text=false;
			state="idle";
		}
	}
}