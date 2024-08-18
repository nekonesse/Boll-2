///CHANGE THESE IN VARIABLE DEFINITIONS
//hp, how many times the player can stomp/damage them, could be useful for things like rexes, or some weird crazy bosses.
//kidhp, how many kid bullets it takes to kill the enemy
//damage_on_contact, this already exists, will hurt the player if they collide with it at all, making it impossible to kill, unless you have a star. if its = 2 it would be invincible to stars aswell.
//no_stomping, this makes it so that the enemy doesnt lose hp/die when being stomped, so it would make it kinda act like an ant trooper from 3d world
//edgeturn, this basically just makes it turn on an edge like a red koopa/goombrat
//defaultgrav, gravity
//hsp, horizontal speed
//vsp, vertical speed
grav=defaultgrav
rot=0
xsc=1
ysc=1
spawn_object=noone

yPlus=0;
inactive=0;
phaseid=0;
turned=0;
piped=0;

killtype="";


image_xscale=1;
image_yscale=1;

//asset_add_tags(object_index, "enemy", asset_object); 