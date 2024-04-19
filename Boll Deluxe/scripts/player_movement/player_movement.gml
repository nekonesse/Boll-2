// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function player_movement(){
	
	x += hsp
	y += vsp
	
	
	if ((apress) && (grounded == false))
	{
	    alarm[1] = 10;  // ammount of frames for jump buffering
	    alarm[2] = 10;  // Walljump buffering
	}
	else if (grounded == true)
	{
	    alarm[2] = 0;
	    wallbuffer = 0;
	}

	if ((alarm[1] > 0) && (grounded == true))
	{
	    bufferjump = 1;
	    alarm[1] = 0;
	}

	move = (right - left);

	maxspd = 2;

	if (move != 0)
	{
	    image_speed = 1;

	    var signmatch = check_signs_matching(hsp, move);
	    var accel_real = ((signmatch) ? accel : fastaccel);

	    hsp += (move * accel_real);

	    hsp = clamp(hsp, -maxspd, maxspd);
	}
	else
	{
	    image_speed = 0;
	    image_index = 0;

		// chearii: mhomentunmnm
		if (grounded)
			hsp = lerp(hsp, 0, fric);
	}
	
	if (grounded) {
		hsp += 0.1 * colslope
	}

	// Fall off platform
	if (!grounded)
	{
	    vsp = min(4, vsp + grav);
	    canjump -= 1;
	
		// chearii: coneyor speed management
		if (abs(chsp * 100))
		{
			chsp *= 0.95;
		
			if ((chsp * 100 div 1) == 0)
				chsp = 0;
		}
	}
	else
	{
	    canjump = 5;  // Coyote frames
	}
	
	
	// Jumping
	if (!akey)
	{
	    if ((canstopjump == 1) && (vsp < -2))
	    {
	        vsp *= 0.6;
	    }
	}

	if ((canjump > 0 && (apress)) 
	    || (bufferjump))
	{
		jump = 1;
	    fr = 1;
	    bufferjump = 0;
		groundtime = 0;
		grounded = false
	    vsp = -6;
	    canjump = 0;
	    canstopjump = 1;
	}

	// Switch direction
	if (left)
	{
	    xsc = -1;
	}
	else if (right)
	{
	    xsc = 1;
	}
}