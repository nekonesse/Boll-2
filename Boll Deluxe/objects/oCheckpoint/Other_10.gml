/// @description Unmark previous checkpoints
instance_activate_object(oCheckpoint)
with (oCheckpoint) {
	if id != other.id && hit {
		hit = 0;
		sprite_index = spr_checkpoint
	}
}