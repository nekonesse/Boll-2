function JumpThrough(obj){
	with(obj) {
		if (other.vsp > 0)
		{
			if place_meeting(x,y-other.vsp,other) && !place_meeting(x,y,other) {
				while(!place_meeting(x,y-1,other) && other.vsp>0)
				{
					other.y+=1;
				}
				other.vsp=0;
				other.collidingsemi=true;
				other.realjump=0;
				other.y = ceil(other.y);
			}

		}
	}
}