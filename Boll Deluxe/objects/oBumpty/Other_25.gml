// Inherit the parent event
event_inherited();

switch(behavior_mode) {
	case bumptyBehaviors.wander_mode:
		timer = irandom_range(60,120);
	break;
	case bumptyBehaviors.flying_mode:
		timer = 180;
		grav=0;
		vsp=0;
		gsp=0;
	break;
	case bumptyBehaviors.jumping_mode:
		walker = false;
		timer = irandom_range(30,90);
		slidetimer = irandom_range(60,120);
	break;
}