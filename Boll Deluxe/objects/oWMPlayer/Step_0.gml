right = input_check("right");
left = input_check("left");
up = input_check("up");
down = input_check("down");
downpress = input_check_pressed("down");
if !finish {
	akey = input_check("a");
	apress = input_check_pressed("a");
	bkey = input_check("b");
	bpress = input_check_pressed("b");
	ckey = input_check("c");
	cpress = input_check_pressed("c");
}

maxspd=2.5;

movedir=point_direction(0,0,right-left,down-up)
if (!left && !right && !up && !down) movedir=-1

if (movedir!=-1) {
	xsc=esign(right-left,xsc);
	
	hsp=(right-left)*maxspd
	vsp=(down-up)*maxspd
	
	repeat(2) {
		x+=hsp/2
		y+=vsp/2
		grounded=false
		player_collision()
	}
	post_wall();
}
catspeak_execute(global.scripts[? $"{charmName}_worldmap"]);