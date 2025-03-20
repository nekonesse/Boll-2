if (phaseid) && !check_hitbox_on_hitbox(phaseid,id) {
	phase_leeway=max(phase_leeway-1,0)
	if !phase_leeway {
		phaseid=noone
	}
}