onConducted=new Signal();

onConducted.Connect( self, function(conductor) {

});

reverse = 0; //should the platform read regular dir or reverse dir
fallen = 0; //whether or not the platform has fallen
vsp = 0; //fallin vsp
grav = 0.15;
radius = 64;

pathing=-1;
pathprenum=0;
pathnum=1;
pathspd=2;
pathcanrev=false;
pathisrev=false;
pathfallen=false;
pathcanfall=false;
pathdraw=true;
pathstarted=true;

dir=0;
spd=0;
depth=5;