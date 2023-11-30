mask_index=spr_goombahitbox

if hp <= 0{
    instance_destroy();
}

if (!damage_on_contact) {
    if place_meeting(x,y-1,oPlayer) && !phaseid && round(instance_place(x,y-1,oPlayer).vsp) > 0 && !(instance_place(x,y-1,oPlayer).hurt) && !(place_meeting(x-1,y,oPlayer) && place_meeting(x+1,y,oPlayer) && instance_place(x,y,oPlayer).grounded)
    {
        if (!no_stomping) hp-=1

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