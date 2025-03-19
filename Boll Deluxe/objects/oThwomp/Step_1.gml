/*if (hp <= 0 && state != 128) {
	damage_on_contact = false;
	state = 128
	ysc = -1
	vsp = -2
	VinylPlay(snd_enemykick)
	instance_create_depth(x,y,2,pImpact)
	killhsp = esign(x - nearestplayer().x, xsc)
	xsc = killhsp
	killtype="spin"
}*/ //you cant kill a thwomp. why is this code here

if (phaseid) && !check_hitbox_on_hitbox(phaseid,id) {
	phase_leeway=max(phase_leeway-1,0)
	if !phase_leeway {
		phaseid=0
	}
}