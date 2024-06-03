dirchange=collision_rectangle(x-1,y-1,x,y,oDirectionChanger,false,true)
if (dirchange) {
	if (dirchange.reverse) reverse=!reverse
	
	if (dirchange.is_break) fallen=1;
	
	if !reverse {
		dir=dirchange.dir
	} else { 
		dir=dirchange.revdir
	}
}

switch (string_lower(dir)) {
	case "right": {
		x+=spd
		break;
	}
	case "left": {
		x-=spd
		break;
	}
	case "up": {
		if !fallen
		y-=spd
		break;
	}
	case "down": {
		if !fallen 
		y+=spd
		break;
	}
}

if (fallen) {
	vsp = min(3,vsp+grav);
	y += vsp;
}

x_diff = x - xprevious;
y_diff = y - yprevious;



if (place_meeting(x, y-4, oEnemy))
{
	var object = instance_place(x, y-4, oEnemy)
	object.x += x_diff;
	object.y += y_diff;
	
}