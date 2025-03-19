// Inherit the parent event
event_inherited();

if instance_exists(myBalloon) {
	myBalloon._owner=noone;
		with(myBalloon) {
		hsp=-other.constantspd;
	}
}