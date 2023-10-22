right=input_check("right");
left=input_check("left");
up=input_check("up");
down=input_check("down");
akey=input_check("jump");
apress=input_check_pressed("jump");
bkey=input_check("action");
bpress=input_check_pressed("action");
ckey=input_check("special");
cpress=input_check_pressed("special");

if (apress) && grounded == false
{	
alarm[1] = 10; //ammount of frames for jump buffering
alarm[2] = 10; //Walljump buffering
}
else if grounded == true
{
alarm[2] = 0;
wallbuffer = 0;
}

if (alarm[1] > 0) && grounded == true
{
bufferjump = 1;
alarm[1] = 0;
}

move = right + -left

maxspd=2

if move != 0
{
image_speed=1
	
hsp += move*accel

hsp = clamp(hsp,-maxspd,maxspd)
}
else
{
image_speed=0
image_index=0
hsp = lerp(hsp,0,fric)
}

//Fall off platform
if !grounded
{
vsp=min(4,vsp+grav)
canjump -= 1
}
else
{
canjump = 5 //Coyote frames
}

if !(akey) {
    if (canstopjump=1 && vsp<-2 ) {
        vsp*=0.6
    }
}

//Jumping
if (canjump > 0 && (apress)) || (bufferjump)
{
jump=1
fr=1
bufferjump = 0;
vsp = -6;
canjump = 0;
canstopjump=1;
}

grounded=false

var _Platform = instance_place(x, y + vsp, oSemilider);
if (_Platform && bbox_bottom <= _Platform.bbox_top) {
	if (vsp > 0) {
		while (!place_meeting(x, y + sign(vsp), _Platform)) {
			y += sign(vsp);
		}
		grounded=true
		vsp = 0;
	}
}
	
coll=instance_place(x+hsp,y,oCollider)
if (place_meeting(x+hsp,y,oCollider) && (coll.object_index!=oFlipblock || (coll.object_index==oFlipblock && coll.hit==0 && !place_meeting(x,y,coll)))){
    yPlus = 0;
    while(place_meeting(x+hsp,y-yPlus,oCollider) && yPlus <= abs(2*hsp)){
        yPlus +=1;
    }
    if(place_meeting(x+hsp, y-yPlus,oCollider)){
        while(!place_meeting(x+sign(hsp),y,oCollider)){
            x += sign(hsp);
        }
        hsp = 0;
    }
    else{
        y -= yPlus;
    }
}
else{
    yMinus = 0;
    while(!place_meeting(x+hsp,y+yMinus,oCollider) && yMinus <= abs(1*hsp)){
        yMinus +=1;
    }
    //still not sure why exactly this needs to be here, but it does for math reasons.
    yMinus -= 1;
    
    //if there is a place of meeting at yMinus (speed+1) but not at yMinus (speed) AND we're already on the ground, move down
    if(place_meeting(x+hsp, round(y+yMinus)+1,oCollider) && !place_meeting(x+hsp, round(y+yMinus),oCollider) && place_meeting(x, y+1,oCollider)) {
        y = round(y+yMinus);
    }
}
x += hsp;

coll=instance_place(x,y+vsp,oCollider)
if (place_meeting(x,y+vsp,oCollider) && (coll.object_index!=oFlipblock || (coll.object_index==oFlipblock && coll.hit==0 && !place_meeting(x,y,coll)))){
    while(!place_meeting(x,round(y+sign(vsp)),oCollider)){
        y += sign(vsp);
    }
    vsp = 0;
	fr=0;
	grounded=true
}
y += vsp;

if !place_meeting(x,round(y),oCollider){
    y=round(y);
}

if (grounded) jump=0


//Switch direction
if (left) 
{
xsc=-1
}
else if (right)
{
xsc=1
}