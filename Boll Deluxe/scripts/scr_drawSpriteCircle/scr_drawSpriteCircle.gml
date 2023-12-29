function draw_sprite_circle(sprite,subimg,xdraw,ydraw,xscale,yscale,radius,quantity,circleAngle){
	var tempReal=0;
	repeat(quantity){
		draw_sprite_ext(sprite,subimg,
		((radius)*sin(tempReal+(circleAngle)))+xdraw,
		((radius)*cos(tempReal+(circleAngle)))+ydraw,
		xscale,yscale,0,#FFFFFF,1)
		tempReal+=(pi*2)/quantity
	}
}