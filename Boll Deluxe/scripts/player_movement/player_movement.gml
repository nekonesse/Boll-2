// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function player_movement(){
	
	x += hsp
	y += vsp
	
	move = (right - left);
	
	if (move != 0) && !(steep_slope || no_move || move_lock)
	{	
		if !(steep_slope || no_move || move_lock) { //dont walk up a slope if its too steep to walk on!
			var signmatch = check_signs_matching(hsp, move);
			var accel_real = ((signmatch) ? accel : fastaccel);

			hsp += (move * accel_real);
		}
	}
	else
	{
		move=0 //just in case
		// chearii: mhomentunmnm
		if (grounded)
		
		if (sign(hsp) = -1){
			hsp = min(0, hsp + fric)
		}else{
			hsp = max(0, hsp - fric)
		}
	}
	
	if (abs(hsp) > maxspd) hsp=approach_val(hsp,maxspd,0.5)
}