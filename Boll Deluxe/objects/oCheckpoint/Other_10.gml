/// @description Unmark previous checkpoints
with (oCheckpoint) {
	if id != other.id && hit {
		hit = 0;
		sprite_index = spr_checkpoint
	}
}