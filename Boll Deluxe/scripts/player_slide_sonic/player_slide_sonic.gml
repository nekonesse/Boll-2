function player_slide_sonic(slope_influence, rolling, roll_up_influence = 0, roll_down_influence = 0) {
	
	var slope = 0
	
	var angle = colangle
	if (angle < 0) angle = 360 + colangle
	
	if grounded {
		if !rolling {
			slope = slope_influence
			if sign(gsp) !=	sign(dsin(colangle)) {
				gsp -= (slope * dsin(colangle))
			} else {
				if(angle > 50 && angle < 360-50) {
					gsp -= (slope * dsin(colangle))
				}
			}
		} else {
			if sign(gsp) !=	sign(dsin(colangle)) {
				slope = roll_down_influence
			}else {
				slope = roll_up_influence
			}
			
			gsp -= (slope * dsin(colangle))
		}
		
		if abs(gsp) < 0.5 {
			if(angle >= 45 && angle <= 360-45 && control_lock = 0) {
				control_lock = 30	
			}
		}
	}
}