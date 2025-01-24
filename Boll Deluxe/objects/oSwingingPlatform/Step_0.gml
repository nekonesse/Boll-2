if (is_blue)
{
	var onscreen = (is_range_onscreen_horizontal(floor(x - 0x78) - 136, floor(x - 0x78) + 136) || (global.netgame));

	if (!onscreen)
	{
		platang_add = 0;
		orbit_angle = spawn_orbit;
		plrcollides = 0;
		playercollidemem = 0;
	}

	//timer = min(32, abs(timer)) * sign(timer);

	var intslow = intlib_make_fixedpoint(0.5);

	if ((abs(swing_speed)||abs(swing_speed div 1)) && (!plrcollides))
	{
		// 32768
		swing_speed = max(abs(swing_speed) - intslow, 0) * sign(swing_speed);
		platang_add = (swing_speed div 1) >> 16;
	}
	
	no_collide = true; // always, ALWAYS true; blue platforms have unique collision
	//ok i get this was based off of SMA2 code but like, man this makes it like 20 times harder to
	//debug. frown.
	thinker_blue_spinning_platform(id);	
}
else
{
	thinker_swinging_platform(id);	
	
	x_diff=floor(x-xprevious);
	y_diff=floor(y-yprevious);
}