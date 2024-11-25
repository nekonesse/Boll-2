if is_array(pathing) && (pathspd) { //prevent crashing & a slight optimization
	var arr=pathing[pathnum];
	
	if (arr[2])
	{
		// curved path, handle special behavior
		var dir=point_direction(pathing[pathprenum][0],
								pathing[pathprenum][1],
								arr[0],
								arr[1]);
	
		// first, get the x and y path distances
		var pathx, pathy;
		
		pathx = arr[0] - pathing[pathprenum][0];
		pathy = arr[1] - pathing[pathprenum][1];
	
		show_debug_message(pathy);
		
		// this is very, very dumb
		targetx+=lengthdir_x(pathspd,dir);
		
		// prevent X from overshooting
		targetx=median(targetx,pathing[pathprenum][0],arr[0]);
		
		// get the x difference
		var xdiff;
		
		xdiff = abs(targetx - pathing[pathprenum][0]);
		
		// do circular easing on the y movement
		
		var curvey = easeMovement(xdiff,max(0.75,abs(pathx))) * pathy;
		
		// clamp y instead of finding the median point
		
		var top, bttm;
		
		top = pathing[pathprenum][1];
		bttm = arr[1];
		
		// FINALLY set the Y value
		targety = median(pathing[pathprenum][1] + curvey, top, bttm);
	}
	else
	{
		var dir=point_direction(targetx,targety,arr[0],arr[1]);
		targetx+=lengthdir_x(pathspd,dir); //move towards the next node
		targety+=lengthdir_y(pathspd,dir);
		targetx=median(targetx,pathing[pathprenum][0],arr[0]); //prevent overshooting
		targety=median(targety,pathing[pathprenum][1],arr[1]);
	}
	
	if !floor(point_distance(targetx,targety,arr[0],arr[1])) { //check if we've reached our destination
		targetx=arr[0]; //snap to our destination just in case we misalign by a margin
		targety=arr[1];
		pathprenum=pathnum;
		if !(pathisrev) {
			if ((array_length(pathing)-1) > pathnum) {
				pathnum++ //if there is another node in our path, continue on
			} else {
				if (pathcanrev) { //can we reverse our pathing?
					pathisrev=true;
					pathnum--; //we have reversed direction, go backwards in our pathing
				} else {
					pathnum=0; //stop running the path code, because why would we? we've stopped.
				}
			}
		} else {
			if (pathnum==0) { //if we have reached the beginning
				pathisrev=false;
				pathnum++; //we have reversed direction, go forwards in our pathing
			} else { //if not, then continue
				pathnum--;
			}
		}
	}
}