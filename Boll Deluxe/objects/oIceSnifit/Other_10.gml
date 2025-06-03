///@description Animation Controller
if !(grounded) sprite_index=spr_goombafall
else if (turning) {
	sprite_index=spr_icesnifit_turn
} else if (stun) {
	sprite_index=spr_icesnifit
} else sprite_index=spr_icesnifit_walk