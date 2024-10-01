var xwidth, ywidth, xx, yy, xb, yb;

// scream and cry and whine if target doesn't exist
if (target == noone)
{
	return;
}

// get rid of lock-based camerastalls if we're not in a CameraLock
if (lockflags)
{
	var this = self;
	with(target)
	{
		if (!place_meeting(x,y,oCameraLock))
		{
			this.lockflags = this.lockflags & IN_LOCK;	
		}
	}
}

// we're stalled; move the camera only
if (stalled)
{
	xwidth = camera_get_view_width(view_camera[0]);
	ywidth = camera_get_view_height(view_camera[0]);

	xx = median(0, xmax, x_final + (x - xprevious) - (xwidth/2));
	yy = median(0, ymax, y_final + (y - yprevious) - (ywidth/2));

	camera_set_view_pos(view_camera[0],xx,yy);
	return;
}

// a div 1 operation would probably be better, but that's probably wasteful
xsensor = intlib_make_u32(CAM_SENSOR_WIDTH * zoom);
ysensor = intlib_make_u32(CAM_SENSOR_HEIGHT * zoom);

// get camera lengths
xwidth = camera_get_view_width(view_camera[0]);
ywidth = camera_get_view_height(view_camera[0]);

// vertical sensors
// chearii: billions must truncate
// is this prone to integer overflows at some point? yeah
// but who the fuck's going to make a stage that's over 9 quintillion pixels tall
// seriously, who
var targety = intlib_make_s64(target.y);

if (!(ycorrect || (lockflags & STALL_Y) || locked))
{
	switch(state[1])
	{
	case 1:
		// exiting course correct
		y = approach_val(y,targety,4);
		if (y == targety)
		{
			state[1] = 0;
		}	
		break;
	default:
		// chearii: rewrite upwards movement so that jitters don't happen ever
		if (y >= targety + ysensor)
		{
			y = intlib_make_s16(targety + ysensor);
		} else if (y < targety) {
			y = floor(targety); // they're both integers now, but I'll leave this alone
			ydist = 0
		}
	}
	y = clamp(y,ymin,ymax);
}

//horizontal sensors
if (!(xcorrect || (lockflags & STALL_X) || locked))
{
	switch state[0] {
		case 0 : { //follow player
			var check = (target.x - x > xsensor || target.x - x < -xsensor); // check boundaries and store
		
			if (xsc == sign(x - target.x)) {x = target.x} // snap to player if they keep going the same direction
		
			xdist = x - round(target.x) // get distance in case camera should pan...
			if (check) { //...if it should, change state
				state[0] = 1
			}
		
		} break;
	
		case 1 : { //camera panning
			xsc = sign(x - target.x) //offset deadzone for state 0
		
			xdist -= sign(xdist) * 2
			x = round(target.x) + xdist; // pan to player
		
			if (round(xdist div 2) == 0) {
				state[0] = 0
			}
		} break;
		case 2: { // exiting course correct
			x = approach_val(x,round(target.x),4);
			if (x == round(target.x))
			{
				state[0] = 0;	
			}
		} break;
		default : {
			x = target.x;
		} break;
	}
	x = clamp(x,xmin,xmax);
}

var xdiff, ydiff;
xdiff = x - xprevious;
ydiff = y - yprevious;

if (((x + xdiff) < xmin) || ((x + xdiff) > xmax))
{
	xdiff = 0;
}

if (((y + ydiff) < ymin) || ((y + ydiff) > ymax))
{
	ydiff = 0;
}

// handle nudges
// SMA4 style, X is dynamic, Y is instant

if (abs(xnudge[1]))
{
	if (sign(xdiff) == sign(xnudge[1]))
	{
		if ((xnudge[0] < xnudge[1]) && (x >= target.x))
		{
			xnudge[0] = min(xnudge[1], xnudge[0] + abs(xdiff));	
		}
		else if ((xnudge[0] > xnudge[1]) && (x <= target.x))
		{
			xnudge[0] = max(xnudge[1], xnudge[0] - abs(xdiff));	
		}
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

// camera modifier collisions
var camnudge, camzoom, camlock;

with(target) {
	camnudge = instance_place(x,y,oCameraNudge);
	camzoom = instance_place(x,y,oCameraZoom);
	camlock = instance_place(x,y,oCameraLock);
}

if (camnudge) {
	xnudge[1] = floor(camnudge.nudge_x);
	ynudge[1] = floor(camnudge.nudge_y);
} else {
	xnudge[1] = 0;
	ynudge[1] = 0;
}

if (camzoom) {
	// CameraZoom regions use a "bigger number = zoom in" format
	// to prevent discrepancy, we gotta do this
	target_zoom = 1 / camzoom.zoom;
} else {
	target_zoom = 1;
}

// do camera lock stuff
var cantmovex = false;
var cantmovey = false;

if (camlock)
{
	// get lock bounds
	var lockx, locky;
	lockx = intlib_make_u32(max(0, camlock.x));
	locky = intlib_make_u32(max(0, camlock.y));
	
	xmin = lockx + (xwidth div 2);
	ymin = locky + (ywidth div 2);
	xmax = min(room_width, lockx + camlock.x_limit) - (xwidth div 2);
	ymax = min(room_height, locky + camlock.y_limit) - (ywidth div 2);
	
	if (xmax < xmin)
	{
		// conflicting bounds, we can't move!
		xmin = xmax;
		cantmovex = true;
	}
	
	if (ymax < ymin)
	{
		// conflicting bounds, we can't move!
		ymin = ymax;
		cantmovey = true;
	}
	
	lockflags |= IN_LOCK;
}
else
{
	if (lockflags & IN_LOCK)
	{
		state[0] = 2;
		state[1] = 1;
		lockflags = (lockflags & ~IN_LOCK);
	}
	xmin = 0;
	ymin = 0;
	xmax = room_width;
	ymax = room_height;
}


// course-correct if we're out of camera bounds
xcorrect = false;
ycorrect = false;

if (x > xmax)
{
	state[0] = 2; // always try and find the player again once everything's said and done
	x = max(xmax, x - 4);
	xnudge[0] = approach_val(xnudge[0],0,4);
	xcorrect = true;
}
else if (x < xmin)
{
	state[0] = 2;
	x = min(xmin, x + 4);
	xnudge[0] = approach_val(xnudge[0],0,4);
	xcorrect = true;
}
else
{
	if (cantmovex)
	{
		x = xmax;
		lockflags |= STALL_X;
	}
}

if (y > ymax)
{
	state[1] = 1;
	y = max(ymax, y - 4);
	ynudge[0] = approach_val(ynudge[0],0,4);
	ycorrect = true;
}
else if (y < ymin)
{
	state[1] = 1;
	y = min(ymin, y + 4);
	ynudge[0] = approach_val(ynudge[0],0,4);
	ycorrect = true;
}
else
{
	y = ((cantmovey) ? ymax : clamp(y,ymin,ymax));
	
	if (cantmovey)
	{
		lockflags |= STALL_Y;
	}
}

x_final = x + xnudge[0];
y_final = y + ynudge[0];

// move and resize the camera
xx = min(room_width, max(0, x_final - (xwidth div 2)));
yy = min(room_height, max(0, y_final - (ywidth div 2)));

// handle zooming
var finxdiff = intlib_make_fixedpoint(abs(xx - x_final_prev));
var finydiff = abs(yy - y_final_prev);

// only let the camera zoom once we actually begin moving
if (zoom_delay)
{
	zoom_delay = max(0, zoom_delay - 1);
}
else if (finxdiff || finydiff)
{
	can_zoom = true;	
}

if (can_zoom)
{
	zoom = approach_val(zoom, target_zoom, CAM_ZOOM_RATE);
}

xb = intlib_make_u32(xbounds * zoom);
yb = intlib_make_u32(ybounds * zoom);

camera_set_view_pos(view_camera[0],floor(xx),floor(yy));
camera_set_view_size(view_camera[0],xbounds * zoom,ybounds * zoom);

x_final_prev = xx;
y_final_prev = yy;