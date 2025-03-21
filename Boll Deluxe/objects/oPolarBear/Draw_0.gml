// Inherit the parent event
if instance_exists(myBalloon) {
	draw_line_color(floor(x)-((6+4*bool(turning))*xsc)-(4*xsc==-1),floor(y)-14,floor(myBalloon.x),floor(myBalloon.y+9),$f0f0f0,$f0f0f0)
}

event_inherited();