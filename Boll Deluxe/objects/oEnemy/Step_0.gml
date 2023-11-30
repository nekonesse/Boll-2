if global.paused || inactive exit

if !place_meeting(x,y+1,oCollider) && !place_meeting(x,y+1,oSemilider)
{
vsp += grav;
}
	
grounded=false

if (edgeturn) && !(turned) && !collision_rectangle(floor(x)+8*sign(hsp),floor(y)+8,floor(x)+9*sign(hsp),floor(y)+9,oCollider,true,true) && !collision_rectangle(floor(x)+8*sign(hsp),floor(y)+8,floor(x)+9*sign(hsp),floor(y)+9,oSemilider,true,true)
{
	turned=1
	hsp=-hsp
}

if collision_rectangle(floor(x)-9,floor(y)+8,floor(x)+9,floor(y)+9,oCollider,true,true) || collision_rectangle(floor(x)-9,floor(y)+8,floor(x)+9,floor(y)+9,oSemilider,true,true) turned=0

coll = instance_place(x+hsp, y-yPlus,oEnemy)

if(coll) && !(coll.inactive){
        coll.hsp = hsp;
		hsp = -hsp;
}

var _Platform = instance_place(x, y + vsp, oSemilider);
if (_Platform && bbox_bottom <= _Platform.bbox_top) {
	if (vsp > 0) {
		while (!place_meeting(x, y + sign(vsp), _Platform)) {
			y += sign(vsp);
		}
		vsp = 0;
	}
}

if (place_meeting(x+hsp,y,oCollider)){
    yPlus = 0;
    while(place_meeting(x+hsp,y-yPlus,oCollider) && yPlus <= abs(2*hsp)){
        yPlus +=1;
    }
    if(place_meeting(x+hsp, y-yPlus,oCollider)){
        while(!place_meeting(x+sign(hsp),y,oCollider)){
            x += sign(hsp);
        }
        hsp = -hsp;
		grounded=true
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

if (place_meeting(x,y+vsp,oCollider)){
    while(!place_meeting(x,round(y+sign(vsp)),oCollider)){
        y += sign(vsp);
    }
    vsp = 0;
	grounded=true
}
y += vsp;

if(!place_meeting(x,round(y),oCollider)){
    y=round(y);
}

if hsp != 0 xsc=-esign(hsp,-1)