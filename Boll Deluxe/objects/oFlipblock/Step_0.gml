player=instance_place(x,y+1,oPlayer)
if (hit==0) && (player) && ((!player.grounded && player.vsp > 0) || player.jump) && !place_meeting(x+1,y,player) && !place_meeting(x-1,y,player) { //temp state check
hit=1
alarm[0]=300
player.vsp = 2
}

image_speed=hit;

if (hit)!=0 {
	mask_index=spr_empty
} else if hit==0 && !place_meeting(x,y,oPlayer) {
	mask_index=sprite_index;
	image_index=0;
}