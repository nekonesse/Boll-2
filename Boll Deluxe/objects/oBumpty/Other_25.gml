// Inherit the parent event
event_inherited();

switch(behavior_mode) {
	case bumptyBehaviors.wander_mode:
		timer = irandom_range(60,120);
		edgeturn = true;
	break;
	case bumptyBehaviors.flying_mode:
		timer = 180;
		grav=0;
		vsp=0;
		gsp=0;
	break;
	case bumptyBehaviors.jumping_mode:
		timer = 15;
		constantspd = 1.5;
	break;
}