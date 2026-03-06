if (active) {
	pal_swap_set(spr_grabblockpal, pal, false);
}

event_inherited();

if (active) {
	pal_swap_reset();
}