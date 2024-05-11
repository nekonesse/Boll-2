dirchange=collision_rectangle(x-1,y-1,x,y,oDirectionChanger,false,true)
if (dirchange) {
	dir=dirchange.dir
}

switch (dir) {
	case "right": {
		x+=spd
		break;
	}
	case "left": {
		x-=spd
		break;
	}
	case "up": {
		y-=spd
		break;
	}
	case "down": {
		y+=spd
		break;
	}
}

x_diff = x - xprevious;
y_diff = y - yprevious;



if (place_meeting(x, y-4, oEnemy))
{
	var object = instance_place(x, y-4, oEnemy)
	object.x += x_diff;
	object.y += y_diff;
	
}