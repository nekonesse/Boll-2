function player_movement_sonic(){
	
	player_warping();
	my_camera.stalled = piped;
	
	if (piped) || (electrocuted) || (electrocution_timer) exit
	
	if !grounded && vsp > -2.5 && vsp < 0 {
		hsp -= (floor(hsp / 0.125) / 512)
	}
	
	if (abs(gsp) > maxspd) && (grounded) gsp=approach_val(gsp, maxspd * sign(gsp), 0.5) 
	if (abs(hsp) > maxspd) && (!grounded) hsp=approach_val(hsp, maxspd * sign(hsp), 0.5)
	
	if (grounded) {
		pollenated = false;
		vsp = gsp * -dsin(colangle)
		hsp = gsp * dcos(colangle)
	}
}