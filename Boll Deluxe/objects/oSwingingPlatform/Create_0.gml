// chearii: previous x and y positions for movement
event_inherited()

//cflags = CF_SOLID;

x_diff = 0;
y_diff = 0;

dir=0;
ydir=0;
spd=0.5;
image_speed=0;
image_index=is_semisolid;
depth=5;
fr=0

orbit_speed = 4;
orbit_length = 64;
orbit_angle = 90;

LDtkReloadFields()

targetx=x;
targety=y;

depth=50;