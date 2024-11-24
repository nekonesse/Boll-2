onConducted=new Signal();

onConducted.Connect( self, function(conductor) {

});

reverse = 0; //should the platform read regular dir or reverse dir
fallen = 0; //whether or not the platform has fallen
vsp = 0; //fallin vsp
grav = 0.15;

pathing=-1;
pathprenum=0;
pathnum=1;
pathspd=2;
pathcanrev=true;
pathisrev=false;

dir=0;
spd=0;
depth=5;