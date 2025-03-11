function player_grab(){
    if (bkey && grabbed_obj == noone) {
        var awesome = collision_line(x,y,x +((hit_sizex + 2) * move_dir),y, oGrabable, false, true) 
        if (awesome && variable_instance_exists(awesome, "grabbed")) {
            grabbed_obj = awesome
			is_grabbing = true
            awesome.grabbed = true
        }
    }
    
    if (grabbed_obj != noone) {
        grabbed_obj.x = x + (xsc * (16))
        grabbed_obj.y = y
        grabbed_obj.grabbed = true
		is_grabbing = true
        
        if (!bkey) {
            if (up) {
                grabbed_obj.vsp = -6
                grabbed_obj.hsp = hsp
            } else if (down) {
                grabbed_obj.vsp = 0
                grabbed_obj.hsp = 0
				grabbed_obj.bounce=false
            } else {
                grabbed_obj.vsp = -1
                grabbed_obj.hsp = (xsc * 3)
            }
            
            grabbed_obj.grabbed = false
            grabbed_obj = noone
			is_grabbing = false
        }
    }
}