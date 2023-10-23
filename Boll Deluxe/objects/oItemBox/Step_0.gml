player=instance_place(x,y+1,oPlayer)
if player && ((!player.grounded && player.vsp > 0) || (player.jump)) { //temp state check
if !(hitted) event_user(0)
oPlayer.vsp = 2
hitted=1
}

if (hitted)
{
	sprite_index=spr_emptybox
	image_speed=0
	if (hit != 0)
	{
		dy=abs(wave_val(0,16,0.2))
		if round(dy)>=2 going=1
		if round(dy)>=14 image_index=1
		if round(dy)==0 && (going) {
			going=0
			hit=0
		}
	}
	event_user(1)
}
else
{
sprite_index=spr_itembox
image_speed=1
}