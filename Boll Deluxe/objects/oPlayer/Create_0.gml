grav=0.25; //we're having an actual grav var now because changing gravity should be EASIER!!
defaultgrav = grav; //for resetting gravity back to default
vsp=0
hsp=0
maxspd = 0; //gets overridden in step event
accel = 0.5; //how fast you gain speed
fric = 0.4; //slipperiness
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

canstopjump=1;
jump=0;

hurt=0;
size=0;
oldsize=0;
image_speed=0
global.paused=0
//instance_change(oPlayerTest,true)