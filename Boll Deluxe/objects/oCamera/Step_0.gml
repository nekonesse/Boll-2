// scream and cry and whine if target doesn't exist
if (target == noone)
{
	return;	
}

//vertical sensors
//TODO: make it not stutter when walking up slopes
var signy = sign(y - round(target.y))
if (y > target.y) {
	if (ydist != 0) {
		ydist = y - round(target.y)
		ydist -= sign(ydist) * 3 //this stutters it
		
		//y = target.y + ydist; 
		y -= sign(ydist) * 3 
		if (round(ydist) div 3 == 0 || signy != sign(y - round(target.y))) {
			ydist = 0
			y = target.y
		}
		
	} else if (target.grounded) {
		ydist = y - round(target.y) //get distance to travel
	}
} else if (y < target.y - 24) {
	y = round(target.y - 24);
	ydist = 0
}


//horizontal sensors
switch state {
	case 0 : { //follow player
		var check = (target.x - x > 64 || target.x - x < -64); // check boundaries and store
		
		if (xsc == sign(x - target.x)) {x = target.x} // snap to player if they keep going the same direction
		
		xdist = x - round(target.x) // get distance in case camera should pan...
		if (check) { //...if it should, change state
			state = 1
		}
		
	} break;
	
	case 1 : { //camera panning
		xsc = sign(x - target.x) //offset deadzone for state 0
		
		xdist -= sign(xdist) * 2
		x = round(target.x) + xdist; // pan to player
		
		if (round(xdist div 2) == 0) {
			state = 0
		}
	} break;
	default : {
		x = target.x;
	} break;
}

// handle nudges
// SMA4 style, X is dynamic, Y is instant

var xdiff;
xdiff = x - xprevious;

if (abs(xnudge[1]))
{
	if (sign(xdiff) == sign(xnudge[1]))
	{
		if (xnudge[0] < xnudge[1])
		{
			xnudge[0] = min(xnudge[1], xnudge[0] + abs(xdiff));	
		}
		else if (xnudge[0] > xnudge[1])
		{
			xnudge[0] = max(xnudge[1], xnudge[0] - abs(xdiff));	
		}
		//xnudge[0] = min(abs(xnudge[1]), xnudge[0] + abs(xdiff)) * sign(xnudge[1]);
	}
}
else if (xnudge[0] != 0)
{
	if (xnudge[0] > 0)
	{
		xnudge[0] = max(0, xnudge[0] - (abs(xdiff) * sign(xnudge[0])));
	}
	else if (xnudge[0] < 0)
	{
		xnudge[0] = min(0, xnudge[0] - (abs(xdiff) * sign(xnudge[0])));
	}
}

if (abs(ynudge[1]))
{
	ynudgespd = (abs(ynudge[1]) / 16);
	ynudge[0] = max(0, min(abs(ynudge[1]), abs(ynudge[0]) + (ynudgespd))) * sign(ynudge[1]);
}
else
{
	ynudge[0] = max(0, abs(ynudge[0]) - ynudgespd) * sign(ynudge[0]);
}

x_final = x + xnudge[0];
y_final = y + ynudge[0];

// nudge collision
var camnudge;

with(target)
{
	camnudge = instance_place(x,y,oCameraNudge);	
}

if (camnudge)
{
	xnudge[1] = camnudge.nudge_x div 1;
	ynudge[1] = camnudge.nudge_y div 1;
}
else
{
	xnudge[1] = 0;
	ynudge[1] = 0;
}

var xwidth, ywidth;

xwidth = camera_get_view_width(view_camera[0]);
ywidth = camera_get_view_height(view_camera[0]);

camera_set_view_pos(view_camera[0],x_final + xdiff - (xwidth div 2),y_final + (y - yprevious) - (ywidth div 2));