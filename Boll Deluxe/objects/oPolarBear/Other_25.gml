// Inherit the parent event
event_inherited();
y-=16
ystart=y

myBalloon=instance_create_depth(x,y-16-(bheight*16),depth-1,oPolarBearBalloon)
myBalloon._owner=id
myBalloon.lineheight=bheight;