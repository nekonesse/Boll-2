function nearestplayer(){
	//returns nearest player instance
	var ret,xp;
	xp=x
	x=-999999999
	ret=instance_nearest(xp,y,oPlayer)
	x=xp
	return ret;
}