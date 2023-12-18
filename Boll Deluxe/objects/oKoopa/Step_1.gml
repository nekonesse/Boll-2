if (in_shell) mask_index=spr_shellhitbox
else mask_index=spr_koopahitbox

if hp <= 0{
    instance_destroy();
}

if (place_meeting(x,y-1,oPlayer)) { //so the player doesnt jump on the damn goombas while warping and shoot into heaven
	if (instance_place(x,y-1,oPlayer).piped) exit
}

if (!damage_on_contact) {
    if place_meeting(x,y-1,oPlayer) && !phaseid && round(instance_place(x,y-1,oPlayer).vsp) > 0 && !(instance_place(x,y-1,oPlayer).hurt) && !(place_meeting(x-1,y,oPlayer) && place_meeting(x+1,y,oPlayer) && instance_place(x,y,oPlayer).grounded)
    {
		if (no_stomping) {
			if (in_shell) {
				if (hsp=0) { 
					enemycoll=false;
					hsp = sign(phaseid.image_xscale) * 2.2;
				}
				else {
					hsp = 0;
					enemycoll=true;
				}
			} else {
				hsp = 0;
				enemycoll=true;
			}
			in_shell = shell_time;
		}

        phaseid=instance_place(x,y-1,oPlayer)
        phaseid.vsp=-4-phaseid.akey*1.5

        exit
    }
    if (phaseid) && !place_meeting(x,y,phaseid) phaseid=0
}

/*
if place_meeting(x+hsp,y,oPlayer) {
	with(instance_place(x,y,oPlayer)) if !hurt knockoPlayer()
}