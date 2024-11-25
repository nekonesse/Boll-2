// chearii: previous x and y positions for movement
event_inherited()

//
// blue platform bullshit
//

// DEBUG: clip position memory
clip_left = 0;
clip_top = 0;

playercollidemem = 0;

is_blue = false;        // are we a blue platform?
plrcollides = 0;

platang_add = 0;        // change in platform angle
platangmem = 0;         // memory of the previous platform angle
platmom = 0;            // momentum to send to the player

plat_sinydiff = 0;      // y difference for blue platforms

coord1 = 0;             // coordinates, used for misc things
coord2 = 0;

collideactive = 0;		// check if collisions are even possible

sinedata = 0;
sinediff = 0;

plat_x = x div 1;       // platform positions
plat_y = y div 1;

semi=true

x_diff = 0;
y_diff = 0;

newx = 0
newy = 0

orbit_angle=0;
spawn_orbit = 0;

dir=0;
ydir=0;
spd=0.5;
image_speed=0;
depth=5;
fr=0

LDtkReloadFields()

image_yscale=1;

if (is_blue)
{
	// set ourselves to the correct spawn position
	x += 72;
	y += 11;
}

if (abs(orbit_angle))
{
	orbit_angle = intlib_make_u16(((orbit_angle) * -182.044) div 1);
	spawn_orbit = orbit_angle;
}

targetx=x;
targety=y;

depth=50;

pathing=-1;
pathprenum=0;
pathnum=1;
pathspd=2;
pathcanrev=true;
pathisrev=false;