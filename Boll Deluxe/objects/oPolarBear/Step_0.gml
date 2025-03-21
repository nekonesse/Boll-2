// Inherit the parent event
event_inherited();

if instance_exists(myBalloon) instance_activate_object(myBalloon);

if !(passive) {
	if (grounded) {
		dashcooldown=max(0,dashcooldown-1);
		dashduration=max(0,dashduration-1);
	}
	if !(upset_walk) {
		overridexsc=true;
		edgeturn=false;
		
		if (targeted_player!=noone) {
			if (dashduration) {
				constantspd=2
				_direction=-xsc;
				edgeturn=false
				dashcooldown=60;
				hurt=false;
				var p=targeted_player
				if esign(x-p.x,xsc)!=xsc {
					dashduration=0;
				}
			} else {
				constantspd=approach_val(constantspd,0,0.1);
				/*var p=nearestplayer();
				if !(dashcooldown) {
					xsc=esign(x-p.x,xsc)
				} 
				if (constantspd) {
					if esign(x-p.x,xsc)==xsc {
						dashduration=60;
						xsc=esign(x-p.x,xsc);
						_direction=-xsc;
						constantspd=2
						hurt=false;
					}
				}*/
			}
		}
	} else { overridexsc=false edgeturn=true}
	
	if !(dashcooldown) && !(dashduration) {
		targeted_player=noone;
		var LOSleft = x-128*xsc //line of sight variables
		var LOSup = y-4
		var LOSright = x+128*xsc
		var LOSdown = y+4
		with(oPlayer) {
			if (rectangle_in_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey, LOSleft, LOSup, LOSright, LOSdown)) && !check_collision_line(x,other.y,other.x,other.y,COL_WALL, other.collision_array) {
				other.targeted_player=id;
				break;
			}
		}
		if (targeted_player!=noone) {
			dashduration=120;
			LOStimer=180;
			xsc=esign(x-targeted_player.x,xsc);
			_direction=-xsc;
			constantspd=2
			hurt=false;
			upset_walk=false;
		} else {
			upset_walk=true;
			constantspd=0.5;
			_direction=-xsc;
			hurt=false;
		}
	}
	
	if (targeted_player!=noone) {
		var LOSleft = x-128*xsc//line of sight variables
		var LOSup = y-4
		var LOSright = x+128*xsc
		var LOSdown = y+4
		if !check_collision_line(x,y,targeted_player.x,y,COL_WALL) { //check if player isnt behind wall
			with (targeted_player) {
				if !(rectangle_in_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey, LOSleft, LOSup, LOSright, LOSdown)) {
					other.LOStimer--;
				}
			}
		} else {
			LOStimer--;
		}
		if !LOStimer {
			targeted_player=noone;
			dashduration=0;
			dashcooldown=0;
			upset_walk=true;
			constantspd=0.5;
			_direction=-xsc;
			hurt=false;
		}
	}
}

if (myBalloon!=noone) {
	instance_activate_region(x-16,y-16-(bheight+4)*16,32,(bheight+6)*16, true)
}