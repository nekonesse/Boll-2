image_speed=0

if !(rolling) && start_rolling==false {
	y=approach_val(y,ystart-32,1)
	image_index=0
	
	if (y==ystart-32) {
		start_rolling=true;
		image_index=1;
		alarm[0]=30;
	}
}

if (rolling) {
	count_timer=approach_val(count_timer,0,1)
	
	if (count_timer)==0 {
		count_timer=4;
		value-=1;
		value=wrap_val(value,0,array_length(values)-1);
	
		image_index=3+value;
	}
}

player=instance_place(x,y+1,oBoardPlayer)
if (player) && (player.jumped) && (!hit) {
player.vsp = 2
player.alarm[1]=120;
event_user(0);
rolling=0
hit=1
}