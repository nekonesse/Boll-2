// Inherit the parent event
event_inherited();

instance_activate_object(oPipe)
with(oPipe) {
	if (warpname == other.warptarget) {
		other.mytargetpipe = id;
		break;
	}
}