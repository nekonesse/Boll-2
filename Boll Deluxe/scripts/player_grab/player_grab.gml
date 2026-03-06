function player_grab(){
    if (bkey && grabbed_obj == noone && can_grab) {
		var graby = y-hit_sizey+2;
		var graby2 = y+hit_sizey-2;
		var grabx = x + ((hit_sizex+2)*xsc)+hsp
		var grabx2 = x;
		
		if (up) {
			graby = y-(hit_sizey+4)+vsp;
			graby2 = y;
			grabx = x-(hit_sizex*xsc)+hsp;
			grabx2 = x + (hit_sizex*xsc)+hsp+(2*move);
		}
		
        var grabbing = collision_rectangle(grabx, graby, grabx2, graby2, oGrabbable, false, true); 
		if (grabbing == noone) {
			grabbing = check_rectangle_in_hitbox(grabx, graby, grabx2, graby2, oEnemy);
		}
        if (grabbing) {
			var can_grab_obj = (object_is_ancestor(grabbing.object_index,oGrabbable) && !grabbing.grab_delay) || (object_is_ancestor(grabbing.object_index,oEnemy) && grabbing.phaseid!=id && grabbing.can_grab) 
			if (can_grab_obj) {
	            grabbed_obj = grabbing
				is_grabbing = true
	            grabbing.grabbed = true
				grabbed_obj.onPickup.Emit(id);
			}
        }
    }
    
    if (instance_exists(grabbed_obj)) {
        grabbed_obj.x = x + (12 * xsc)
        grabbed_obj.y = y
        grabbed_obj.grabbed = true
		is_grabbing = true
        
        if (!bkey) {
			if !(down) && !(up) {
				grabbed_obj.x = x;
			}
            grabbed_obj.onThrown.Emit(id);
			sig.Emit("throw_object");
            
            grabbed_obj = noone
			is_grabbing = false
        }
    } else {
		grabbed_obj = noone;
	}
}