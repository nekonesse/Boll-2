pal_swap_init_system(shd_pal_swapper)
palette=0
palette_index=0

grav=0.25; //we're having an actual grav var now because changing gravity should be EASIER!!
defaultgrav = grav; //for resetting gravity back to default
vsp=0;
hsp=0;

// chearii: we SRB2 in this house (conveyor speeds for moving platforms)
chsp = 0;
cvsp = 0;

maxspd = 0; //gets overridden in step event

// chearii: accel and friction were 0.5 and 0.4, respectively. I'm just changing them to their SMW values
accel = 0.09375; //how fast you gain speed
fastaccel = 0.3125; // accel during a turnaround
fric = 0.0625; //slipperiness
move=0

xsc=1
ysc=1
rot=0
fr=0

realjump = 0;
canjump = 0;
bufferjump = 0;
wallbuffer = 0;
move_lock = false;
piped = false; //tell me if you want this gone ok thanks
grounded = false;
dead = 0;
carrying = 0;
run=0;
collflags = 0; // collision flags

sprindex_prev = sprite_index;

canstopjump=1;
jump=0;
steps = 0
colslope = 0
hurt=0;
size=0;
oldsize=0;
image_speed=0
global.paused=0
depth=0;
drawStar=false 
//mycollisions = ds_list_create()
//feel free to delete this along with it's mentions and uses in the draw event
//instance_change(oPlayerTest,true)

// fracval setup
//setup_frac(self);

// boxpoly setup
//setup_box_poly(self);

// slope setup
//instance_make_slopevars(self);