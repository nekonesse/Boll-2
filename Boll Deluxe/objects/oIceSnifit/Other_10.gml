///@description Animation Controller

if (turning) {
	sprite_index=spr_icesnifit_turn
} else if (stun) {
	if (stun > 30) {
		sprite_index=spr_icesnifit_stun
	} else {
		sprite_index=spr_icesnifit_getup
	}
} else if (blowing) {
	sprite_index=spr_icesnifit_blow
} else if (revving) {
	sprite_index=spr_icesnifit_rev
	if image_index>=image_number-1 {
		image_index=image_number-1;
	}
} else {
	sprite_index=spr_icesnifit_walk
}