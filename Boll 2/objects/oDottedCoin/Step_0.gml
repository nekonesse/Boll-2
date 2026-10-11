node_path_movement();
image_index=floor(global.roomTimer/sprite_get_speed(sprite_index))

if (timer) && (triggered) {
	timer--
	
	if !(timer) {
		var i=instance_create_depth(x,y,0,oCoin)
		with (i) {
			pathing=other.pathing;
			pathprenum=other.pathprenum;
			pathnum=other.pathnum;
			pathspd=other.pathspd;
			pathisrev=other.pathisrev;
			pathfallen=other.pathfallen;
			pathdraw=other.pathdraw;
			pathstarted=other.pathstarted;
			pathstarttype=other.pathstarttype;
			pathendtype=other.pathendtype;
			rotdat=other.rotdat;
			rotangle=other.rotangle;
			rotdist=other.rotdist;
			rotorgx=other.rotorgx;
			rotorgy=other.rotorgy;
			rotspd=other.rotspd;
			rotating=other.rotating;
		}
		instance_destroy();
	}
}