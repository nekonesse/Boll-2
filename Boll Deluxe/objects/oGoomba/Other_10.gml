///@description Animation Controller
if !(grounded) sprite_index=spr_goombafall
else if (turning) {
	sprite_index=spr_goombaturn
} else if (stuck) {
	sprite_index=spr_goombastuck
}else {
	sprite_index=spr_goombawalk
}