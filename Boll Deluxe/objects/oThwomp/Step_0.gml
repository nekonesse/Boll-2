var col = noone;
if (state = 0) {
	if collision_rectangle(x-40,y,x+40,y+512,oPlayer,true,true) {
		state = 1
	}
} else if (state = 1) {
	vsp = approach_val(vsp,5,0.5)
	col=instance_place(x,y+vsp,oCollider)
	if col {
		state = 2
		vsp = 0
		timer_offset = 90
		y = col.bbox_top
		VinylPlay(snd_enemycannon)
	}
} else if (state = 2) {
	if !timer_offset {
		y = approach_val(y,ystart,1)
	}
	timer_offset -= 1
	if (y == ystart) {state = 0}
}