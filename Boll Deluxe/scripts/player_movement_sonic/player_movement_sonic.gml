// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function player_movement_sonic(){
	
	player_warping();
	my_camera.stalled = piped;
	
	if (piped) exit
	
	if !(no_move)
	move = (right - left);
	
	if (move != 0) && !(steep_slope || no_move || move_lock)
	{	
		//dont walk up a slope if its too steep to walk on!
		
		if grounded {
			var signmatch = check_signs_matching_zero(gsp, move);
			//var accel_real = ((signmatch) ? accel : fastaccel);
			if signmatch {
				if (abs(gsp) < topspd) && accel != 0 {
					gsp += (move * accel);
					if (abs(gsp) > topspd) {
						gsp = topspd * sign(gsp);
					}
				}
			} else {
				gsp += (move * fastaccel);
			}
		}else {
			var signmatch = check_signs_matching(hsp, move);
			//var accel_real = ((signmatch) ? accel : fastaccel);
			if signmatch {
				if (abs(hsp) < topspd) && accel != 0 {
					hsp += (move * accel);
					if (abs(hsp) > topspd) {
						hsp = topspd * sign(hsp);
					}
				}
			} else {
				hsp += (move * fastaccel);
			}
		}
		
	}
	else
	{
		move=0 //just in case
		// chearii: mhomentunmnm
		
		if (grounded) {
		
			if (sign(gsp) = -1){
				gsp = min(0, gsp + fric)
			}else{
				gsp = max(0, gsp - fric)
			}
		}
	}
	
	if !grounded && vsp > -4 && vsp < 0 {
		hsp -= (hsp / 128)	
	}
	
	if (abs(gsp) > maxspd) && (grounded) gsp=approach_val(gsp, maxspd * sign(gsp), 0.5) 
	if (abs(hsp) > maxspd) && (!grounded) hsp=approach_val(hsp, maxspd * sign(hsp), 0.5)
	
	if (grounded) {
		vsp = gsp * -dsin(colangle)
		hsp = gsp * dcos(colangle)
	}
	
	x += hsp 
	y += vsp
}